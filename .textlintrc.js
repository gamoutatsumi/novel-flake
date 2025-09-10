module.exports = {
	plugins: ["latex2e"],
	filters: {},
	rules: {
		// 一般的な小説スタイルに沿っていなければエラー
		// 例: 三点リーダとダッシュの個数が2の倍数ではない。段落の先頭の字下げが無い。
		"general-novel-style-ja": {
			chars_leading_paragraph: "　「『（【〈《“‘［〔｛＜",
			max_arabic_numeral_digits: false, // アラビア数字の桁数は気にしない (Web小説向けのため)
		},

		// 一文中に読点が3つ以下でなければエラー
		"max-ten": {
			max: 3,
			kuten: ["。", "」", "』"],
		},

		// アルファベットは全角のみ許可
		"no-mixed-zenkaku-and-hankaku-alphabet": {
			prefer: "全角",
		},

		// 同じ助詞が連続したらエラー
		"no-doubled-joshi": {
			min_interval: 1,
			separatorCharacters: ["。", "？", "！"],
			commaCharacters: ["、"],
		},

		// 段落内で同じ接続詞が出現したらエラー
		"no-doubled-conjunction": true,

		// 一般的な誤用を検出
		// @see https://github.com/textlint-ja/textlint-rule-ja-no-abusage
		"ja-no-abusage": true,

		// 冗長な表現はエラー
		// 例: 「操作を行う」
		"ja-no-redundant-expression": true,

		// 「〜たり〜たり」になっていなければエラー
		"prefer-tari-tari": true,

		// 全角文字の間に混入した半角スペースを検出
		"textlint-rule-ja-no-space-between-full-width": true,

		// タイプミスで混入したっぽい半角アルファベットを検出
		"ja-unnatural-alphabet": {
			allow: ["/[Ａ-Ｚ]/"],
		},
	},
};
