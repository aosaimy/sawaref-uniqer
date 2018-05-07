#!/usr/bin/env node

/**
This file parse the content (from the standard input) of the raw results of the tool 
and do some postprocessing as required.
*/


// parser.js
"use strict";
var buckwalter = require('buckwalter-transliteration');
buckwalter.bw2utf = buckwalter("bw2utf")
buckwalter.utf2bw = buckwalter("utf2bw")
var md5 = require('md5');
//var csv = require('csv-streamify');
var fs = require('fs');
var JSONStream = require('JSONStream');
var es = require('event-stream');
// const path = require('path');
var qa_to_sawalha_mapping = require('./mappings/qa_to_sawalha_mapping');
var all_to_qa_mapping = require('./mappings/all_to_qa_mapping');
var posMapping = require('./mappings/tagset');
// var all = {}; //= JSONStream.stringify();

var include = require('./include');

class SawarefUniquer {
    constructor(argv) {
        this.tools = []
        this.raw1 = null
        this.raw2 = null
        this.name = null
        this.inited = false
        this.stringifier = null
        this.keys = {
            // wrong -> correct

        }
        this.sawalha = qa_to_sawalha_mapping
        this.positions = {
            // "pos": 1,
            "mood": 11,
            "case": 11,
            "aspect": 3,
            "gender": 7,
            "person": 9,
            "number": 8,
            "voice": 14,
            "state": 13,
        }
        this.values = all_to_qa_mapping
        this.ignore = ["tokens", "utf8", "gloss", "bw", "lem", "stem", "root", "lexmepattern", "structure", "num", "morphemes", "idonno", "twonum"]
        this.init(argv)
    }
    init(argv) {
        if (this.inited)
            return
        if (argv.tag == "all" || argv.tag == "choosed")
            this.choosed = JSON.parse(fs.readFileSync('/morpho/backup/chosedSolutions.json', 'utf8'));

        if (argv.tag == "all" || argv.tag == "checked")
            this.checked = JSON.parse(fs.readFileSync('/morpho/backup/checkedSolutions.json', 'utf8'));

        if (argv.e) {
            var stringify = require('csv-stringify');
            this.stringifier = stringify({
                columns: ["tool", "origTAG", "destTAG", "isAmbiguious", "example"]
            })
            this.stringifier.pipe(fs.createWriteStream(argv.e, {
                flags: "a"
            }));
            this.examples = [];
        }
        this.name = argv.name

        if (argv.align && ["ru", "sp", "un", "ch", "st", "gs"].indexOf(argv.align) < 0) {
            console.error("Usage: --align [ru,sp,un,ch,st]");
            process.exit();
        }

        this.debug = argv.d ? true : false;

        // if(argv.m == "all")
        // this.posMapping = posMapping;
        this.values.pos = posMapping || {}
    }


    preprocess() {
        var that = this
        return function(data, key) {
            // case no word alignment requested
            var d = {
                key: key[0],
                data: data
            }
            if (!argv.raw || argv.raw === true) {
                // this.emit("data",d)
                return d;
            }

            //case alignment is based on non-seg input, diac input or input segmented using FA)
            if (key[0] == "Raw" || key[0] == "RawDia" || key[0] == "RawSeg")
                if (key[0] == argv.raw) {
                    that.raw1 = d.data;
                }

            if (key[0] == "Words") {
                // preprocessing
                Object.keys(d.data).forEach(e => d.data[e] = d.data[e].filter(f => f !== null).map(f => {
                    return f.replace(/[\u064b-\u065f]/g, '').replace("\n", "") // shortvowels}))
                }))
                that.raw1 = that.raw1.map(f => {
                    return f.replace(/[\u064b-\u065f]/g, '').replace("\n", "") // shortvowels}))
                })
                if (!that.raw1) {
                    that.raw1 = d.data[argv.raw];
                }
                if (!that.raw1) {
                    console.error("arg: raw is not valid")
                    this.emit("data",d)
                    return d;
                }

                that.words = d.data;

                var mispen = 10, //not doing anything
                    gappen = 1.0, //
                    skwpen = 0.5; //


                for (var i in d.data) {
                    if (i == argv.raw)
                        continue
                    if (i != "FA")
                        continue
                    include.stringalign(d.data[i], that.raw1, mispen, gappen, skwpen)
                    console.error("Warning: Word Alignment is not enabled!");
                    // console.error(d.data[i].join("\t"));
                    // console.error(this.raw1.join("\t"));
                    // // console.error(result)
                    // console.error("----------------")
                    // console.error(result.a.join("\t"))
                    // console.error(result.b.join("\t"))
                    // console.error(result.s.join("\t"))
                }

                // if(this.debug) console.log(result);

                // var line = []
                // for(var i=j=0, ii=0,jj=0,x=0; i<result.a.size && j<result.b.size; i++, j++){
                //     if(result.a[i]!=" " && result.b[j]!=" ")
                //         line.push([jj++,ii++]);
                //     else if(result.a[i]!=" ")
                //         line.push(["X",ii++]);
                //     else if(result.b[j]!=" ")
                //         line.push([jj++,"X"]);
                // }
            }
            // this.emit("data",d)
            return d;
        }
    }
    processWord(word, tool, wid, argv) {
        var s = [argv.n, wid, tool].join("-")
        if (argv.tag == "checked" || argv.tag == "all")
            word.iscorrect = this.checked[s];

        if (argv.tag == "choosed" || argv.tag == "all")
            if (!word.analyses || word.analyses.length === 0) {
                if (!word.error) word.error = "No analyses"
            }
        else if (word.analyses.length == 1)
            word.choice = 0;
        else if (this.choosed[s])
            word.choice = this.choosed[s];
        else if (word.choice !== undefined)
            word.choice = word.choice;
        else {
            // for (var k in word.analyses) {
            //     var a = word.analyses[k];
            //     word.analyses[k].dist = getEditDistance(a.utf8, d[whichRaw][wid]);
            // }
            if (!this.raw2[wid])
                console.error("Source input is not defined for", wid);

            word.analyses.forEach(function(obj) {
                obj.dist = include.getEditDistance(this.utf8, this.raw2[wid]);
            }, word)
            if (word.analyses && word.analyses.sort) {
                word.analyses.sort(function(a, b) {
                    if (a.dist > b.dist)
                        return 1;
                    else if (a.dist < b.dist)
                        return -1;
                    return 0;
                });
                // var dist = word.analyses[0].dist;
                // var aaa = word.analyses.filter(function(obj){
                //     return obj.dist == dist;
                // })
                // if(aaa.length == 1){
                //     word.analyses = aaa;
                //     word.choice = 0;
                // }
            } else {
                console.error(word);
            }

        }

        // Uniquer
        if (argv.t && word.analyses) {
            word.analyses.forEach(function(obj) {
                obj.utf8 = obj.utf8 ? include.removeFinalTaskeel(include.basicTaskeel(obj.utf8)) : "";
                obj.mutf8 = "";
            }, word)
        }

        var setMutfAndUtf = function(aid) {
            return function(obj) {
                word.analyses[aid].mutf8 = word.analyses[aid].mutf8 + obj.utf8;
                obj.utf8 = obj.utf8 ? include.removeFinalTaskeel(include.basicTaskeel(obj.utf8)) : "";
            }
        }
        for (var aid in word.analyses) { // analyses

            if (argv.t)
                word.analyses[aid].morphemes.forEach(setMutfAndUtf(aid), word)

            for (var mid in word.analyses[aid].morphemes) { // morpheme
                if (argv.m) {
                    word.analyses[aid].morphemes[mid].map = {};
                    for (var k in word.analyses[aid].morphemes[mid]) { // key
                        var x = null;
                        //pos tagging
                        if (argv.m == "all" && k == "pos" && this.values[k]) {
                            var v = word.analyses[aid].morphemes[mid][k].trim().replace("–", "-");
                            if (!this.values[k][tool]) {
                                console.error("tool is undefined", k, tool);
                                continue;
                            }
                            var value = this.values[k][tool][v];
                            if (!value) {
                                // key (original TAG) in the list of POS tag set is not found
                                if(tool=="QA" && k =="pos"){
                                    word.analyses[aid].morphemes[mid].map[k] = word.analyses[aid].morphemes[mid][k]
                                }
                                else{
                                    console.error("value is undefined", v, "@", tool, k);
                                    word.analyses[aid].morphemes[mid].map[k] = ""
                                }

                                
                            } else if (value.length > 1) {
                                // multiple options!
                                // TODO research!
                                if (argv.e)
                                    this.stringifier.write({
                                        "tool": tool,
                                        "origTAG": word.analyses[aid].morphemes[mid][k],
                                        "destTAG": value,
                                        "isAmbiguious": "true",
                                        "example": word.analyses[aid].morphemes[mid].utf8
                                    });

                                word.analyses[aid].morphemes[mid].map[k] = "";
                            } else {
                                if (argv.e)
                                    this.stringifier.write({
                                        "tool": tool,
                                        "origTAG": word.analyses[aid].morphemes[mid][k],
                                        "destTAG": value[0],
                                        "isAmbiguious": "false",
                                        "example": word.analyses[aid].utf8
                                    });
                                word.analyses[aid].morphemes[mid].map[k] = value[0].replace(/\|.*/, "")
                            }


                        } else if (this.values[k]) { // in case I forgot to put the key
                            if (typeof word.analyses[aid].morphemes[mid][k] == "string")
                                x = this.values[k][word.analyses[aid].morphemes[mid][k].toLowerCase()];
                            else
                                x = this.values[k][word.analyses[aid].morphemes[mid][k]];

                            word.analyses[aid].morphemes[mid].map[k] = x || "";
                        }
                    }
                    if (argv.s) {
                        //SAWALHA TAG
                        var str = [];
                        for (var e = 0; e < 22; e++) {
                            str[e] = "-";
                        }
                        for (let k in this.positions) {
                            let value = word.analyses[aid].morphemes[mid].map[k];
                            //translate it
                            value = this.sawalha[k][value];
                            str[this.positions[k]] = !value ? "-" : value;
                        }

                        if (!word.analyses[aid].morphemes[mid].map.mood) {
                            let value = word.analyses[aid].morphemes[mid].map.case;
                            value = this.sawalha.case[value];
                            str[11] = !value ? "-" : value;
                        } else if (!word.analyses[aid].morphemes[mid].map.case) {
                            let value = word.analyses[aid].morphemes[mid].map.mood;
                            value = this.sawalha.mood[value];
                            str[11] = !value ? "-" : value;
                        } else if (word.analyses[aid].morphemes[mid].map.case === "" && word.analyses[aid].morphemes[mid].map.mood === "") {
                            str[11] = "-";
                        } else {
                            // console.error(word.analyses[aid]);
                            console.error("case or mood not empty", word.analyses[aid].morphemes[mid].case, word.analyses[aid].morphemes[mid].mood)
                        }
                        word.analyses[aid].morphemes[mid].sawalaha = str.join("");
                        if (argv.md5)
                            word.analyses[aid].morphemes[mid].md5 = md5(str.join("")).substr(0, 5)
                    }
                }
            }
            if (!word.error && argv.md5)
                word.analyses[aid].md5 = md5(word.analyses[aid].morphemes.map(o => o.md5).join("")).substr(0, 5)
        }
        if (!word.error) {
            if (!word.analyses)
                console.error(word);
            if (argv.md5)
                word.md5 = md5(word.analyses.map(o => o.md5).join("")).substr(0, 5)
        } else if (argv.md5)
            word.md5 = md5(word.error).substr(0, 5)
        return word
    }
    process(d, key, argv, th) {
        if (!d.key) {
            console.error("Input JSON file is not valid.")
            console.error(d)
            process.exit(1)
        }
        var tool = d.key;
        var data = d.data
        if (tool == "RawDia") {
            this.raw2 = data;
            th.emit("data", [tool, data])
            return
        } else if (tool == "Raw") {
            if (!this.raw2)
                this.raw2 = data;
            th.emit("data", [tool, data])
            return
        } else if (tool == "RawSeg") {
            if (!this.raw2)
                this.raw2 = data;
            th.emit("data", [tool, data])
            return
        } else if (tool == "Words") {
            th.emit("data", [tool, data])
            return
        }

        if (tool.length != 2)
            return undefined;
        this.tools.push(tool)
        //data
        for (var wid in data) { //words
            data[wid] = this.processWord(data[wid], tool, wid, argv)
        }
        th.emit("data", [tool, data])
        return
    }

}

if (require.main === module) { // called directly
    var argv = require('yargs')
        .usage('Usage: $0 [-m all|exceptPos] [-st] [-e example_filename] -f filename')
        .default('f', "/dev/stdin")
        // .default('posMapping',path.join(".","mappings/tagset.json")).describe('posMapping','path to POS mapping file')
        .demand('n').describe('n', 'Name of input e.g. 29-10')
        .describe('raw', 'toolname or RAW to use as the pivot for word alignment. Word Alignment is not done otherwise.')
        .describe("m", "(all|exceptPos) map each feature (gender, person, etc) to a unique value as in SAWALHA")
        .boolean("s").describe("s", "map each analysis to SAWLAHA 22-feature represetation. requires -m to work.")
        .describe("tag", "(choosed|checked|all) mark the choosed/checked/both analysis according to output of manual disamiguation done in SAWALHA.")
        .describe("e", " (filename) write a CSV file of examples ")
        .boolean("t").describe("t", "process the taskeel according to edit distance")
        .boolean("md5").describe("md5", "compute md5 check sum. requires -s to work.")
        .describe("tool", "unique only one tool.")
        .describe("align", "(ru)le-based,(sp)ervised,(un)supervised,(ch)ar-based,(st)em-and-affixes]")
        .argv

    var sawarefUniquer = new SawarefUniquer(argv)
    sawarefUniquer.init(argv)

    let r = fs.createReadStream(argv.f, { encoding: "utf-8" })
    if (!argv.tool) // not oneTool
        r = r.pipe(JSONStream.parse("*",sawarefUniquer.preprocess()))
    else
        r = r.pipe(JSONStream.parse("*")).pipe(es.through(function(data){
                this.emit("data",{key:argv.tool,data:data})
            }))
    var p = main(r, argv)

    if (p){
        if (argv.tool)
            p.pipe(JSONStream.stringify()).pipe(process.stdout)
        else
            p.pipe(JSONStream.stringifyObject()).pipe(process.stdout)
    }
    process.stdout.on('error', process.exit);

    process.stdout.on('finish', function() {
        console.error(JSON.stringify(SawarefUniquer.examples));
    });

} else {
    exports.allTools = {
        uniqueFromFile: function(fileInput, tools, name, opts) {
            if (!opts)
                opts = {}
            opts.n = name
            opts.f = fileInput
            // return main(fs.createReadStream(fileInput,{encoding:"utf-8"}),{
            //     // "tool" : tool,
            //     "source" : fs.readFileSync(sourceFile, "utf8")
            // })
            return main(
                fs.createReadStream(fileInput, { encoding: "utf-8" })
                .pipe(JSONStream.parse("*", function(data, key) {
                    return [key[0], data];
                })), opts)
        },
        uniqueFromJSON: function(input, tools, opts) {
            if (!opts)
                opts = {}
            var Readable = require('stream').Readable
            var instream = new Readable()
            if (Array.isArray(input))
                input.forEach(x => instream.push(x))
            else
                instream.push(input)
            instream.push(null) // indicates end-of-file basically - the end of the stream
            return main(instream, opts)
        }
    }
    exports.oneTool = {
        uniqueFromJSON: function(instream, tool, raw, opts) {
            opts.tool = tool
            return main(instream.pipe(es.through(function(data){
                this.emit("data",{key:opts.tool,data:data})
            })), opts)
        }
    }
}

function main(instream, argv) {
    var sawarefUniquer = new SawarefUniquer(argv)
    sawarefUniquer.init(argv)
    var r = instream

    // console.log(r,argv)

    var counter = 0
    if (argv.tool) // oneTool
        return r.pipe(es.through(function(word) {
            // console.log(word)
            this.emit("data", sawarefUniquer.processWord(word.data, argv.tool, counter++, argv))
        }))
    else
        return r.pipe(es.through(function(a, b) {
            return sawarefUniquer.process(a, b, argv, this)
        }, function() { //optional
            this.emit("data", ["META", {
                name: argv.n,
                date: new Date(),
                tools: sawarefUniquer.tools.join(":")
            }]);
            this.emit('end')
        }))
}