module.exports = {
    // wrong -> correct
    "pos": {},
    "mood": {
        //Mada
        "i": "IND",
        "s": "SUBJ",
        "j": "JUS",
        //QA
        "ind": "IND",
        "subj": "SUBJ",
        "jus": "JUS",
        //Elixir
        "e": "ENG",
        "u": "",
        "na": "",
        "-": ""
    },
    "aspect": {
        //AraComLex
        "pres": "IMPF",
        "past": "PERF",
        "imp": "IMPV",
        //QA
        "impf": "IMPF",
        "perf": "PERF",
        "impv": "IMPV",
        //Mada, Elixir
        "i": "IMPF",
        "c": "IMPV",
        "p": "PERF",
        "na": "",
        "-": "",
        //Alkhalil, stanford
        "imperfect": "IMPF",
        "imperative": "IMPV",
        "imparative": "IMPV",
        "perfect": "PERF",
        //BW
        "imperfective": "IMPF",
        "perfective": "PERF"
        //ATKS
    },
    "gender": {
        //male
        "masc": "M",
        "m": "M",
        "male": "M",
        //female
        "fem": "F",
        "f": "F",
        "female": "F"
    },
    "person": {
        "1": "1",
        "2": "2",
        "3": "3",
        "f": "1",
        "s": "2",
        "t": "3"
    },
    "number": {
        //singular
        "sg": "S",
        "s": "S",
        "singular": "S",
        "sing": "S",
        //dual
        "dual": "D",
        "d": "D",
        //plural
        "pl": "P",
        "p": "P",
        "plural": "P",
        "plu": "P"
    },
    "case": {
        // ??? -> ENG no one?!

        //ALkhalil
        "accusative": "ACC",
        "genitive": "GEN",
        "nominative": "NOM",

        //Mada
        "u": "-",
        "a": "ACC",
        "g": "GEN",
        "n": "NOM",

        //elixir
        "1": "NOM",
        "2": "ACC",
        "4": "GEN",

        //ATKS, aracomlex
        "nom": "NOM",
        "acc": "ACC",
        "gen": "GEN",
        "na": "",
        "-": ""
    },
    "voice": {
        "active": "ACT",
        "passive": "PASS",
        "a": "ACT",
        "p": "PASS",
        "act": "ACT",
        "pass": "PASS"
    },
    "state": {
        //mada
        "i": "INDEF",
        "d": "DEF",

        "c": "-", //????

        //AlKhalil
        "def": "DEF",
        "indef": "INDEF",
        "gen": "-", // ????

        //elixir
        "EXi": "INDEF",
        "EXd": "DEF",
        "r": "MDAF", // ???? gen in AlKhalil (mDAf)
        "a": "-", // ???? blA tnwyn
        "EXc": "DEF", // ???? mDAf mErfp
        "l": "INDEF" // ???? mDAf blA tEryf

    }
}