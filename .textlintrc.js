module.exports = {
	plugins: ["latex2e"],
	filters: { comments: true },
	rules: {
		"general-novel-style-ja": {
			chars_leading_paragraph: "　「『（【〈《“‘［〔｛＜",
			space_after_marks: false,
		},

		"max-ten": {
			max: 3,
			kuten: ["。", "」", "』"],
		},

		"no-mixed-zenkaku-and-hankaku-alphabet": {
			prefer: "全角",
		},

		"no-doubled-joshi": {
			min_interval: 1,
			separatorCharacters: ["。", "？", "！"],
			commaCharacters: ["、"],
		},

		"no-doubled-conjunction": true,

		"ja-no-abusage": true,

		"ja-no-redundant-expression": true,

		"prefer-tari-tari": true,

		"textlint-rule-ja-no-space-between-full-width": true,

		"ja-unnatural-alphabet": {
			allow: ["/[Ａ-Ｚ]/"],
		},
	},
};
