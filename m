Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2KGC0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 21:26:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10869 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KGC0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 21:26:38 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-43-5099c6dd61b3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <20121030144412.4a4a60dc0dace86f1a91af8c@canb.auug.org.au>
In-reply-to: <20121030144412.4a4a60dc0dace86f1a91af8c@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the samsung tree with the pinctrl tree
Date: Wed, 07 Nov 2012 11:26:36 +0900
Message-id: <0c4401cdbc8f$4ff0f8b0$efd2ea10$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22UN3k4n7dn9LQT1yFcdaN5NT39AGM+5jQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY927x2YGGJzdIW5xedccNouDC9sY
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo48n0bS0Ena8XtVW/ZGhg7WboYOTkkBEwkvh5shrLF
	JC7cW8/WxcjFISSwjFGi//lzuKJzV08xQiSmM0r8/vGVGcL5yygx98N1NpAqNgENicPvn7GD
	2CICuhJ9/+YzgRQxCxxklPg36SRQggOow03i24UykBpOAXeJ5tu7wcLCAv4SLYcdQcIsAqoS
	l85+YwWxeQVsJa5dmcwEYQtK/Jh8D+wgZgEtifU7jzNB2PISm9e8ZQYZIyGgLvHory7EBUYS
	rc2LGCFKRCT2vXjHCDFeQOLb5EMsEOWyEpsOgH0iIbCKXaLn6G9miH8lJQ6uuMEygVFiFpLN
	s5BsnoVk8ywkKxYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECIkxqR2MKxssDjEKcDAq
	8fBOSJ8ZIMSaWFZcmXuIUYKDWUmE900MUIg3JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPzgfGf
	VxJvaGxsYmZiamJuaWpuikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAPjzPWltitm3F+d
	VRGX9eIQR4CXncKUo/+5TN2rapT0w5f8tea+9aNDQDle+VHX8TRPtvrPP+oNuU/OXPn7tLPu
	om4308YFPZ9rklrjtdLfvdpUY3iy9omq0F5xHdO3qx7ys3288vTbjBSBJXuzJBfNKNNfki96
	tDDIobWZ72xc2tl5L+XvrU1VYinOSDTUYi4qTgQA6D6+m94CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd27x2YGGLx5JWxxedccNouDC9sY
	HZg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOPJ9G0tBJ2vF
	7VVv2RoYO1m6GDk5JARMJM5dPcUIYYtJXLi3nq2LkYtDSGA6o8TvH1+ZIZy/jBJzP1xnA6li
	E9CQOPz+GTuILSKgK9H3bz4TSBGzwEFGiX+TTgIlOIA63CS+XSgDqeEUcJdovr0bLCws4C/R
	ctgRJMwioCpx6ew3VhCbV8BW4tqVyUwQtqDEj8n3wI5jFtCSWL/zOBOELS+xec1bZpAxEgLq
	Eo/+6kJcYCTR2ryIEaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnAEP5PawbiyweIQowAHoxIP74T0mQFCrIllxZW5hxglOJiVRHjfxACF
	eFMSK6tSi/Lji0pzUosPMfoAPTqRWUo0OR+YXPJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQI
	CaQnlqRmp6YWpBbBjGPi4JRqYDRT+7370nWvG1u9LO1fen4K7miYtX1B4e3v+ukBJivjNERf
	Hb2f1bw0vrB2f9r66CyWI74dioVKafOvvhf6OsO24d7BAA2h+Wmuq+2lPu2w7Tc+xfSWpd8w
	4dLXkrWufB4nc69freKtOfth5uz94rt18wq+cOYdTkh57ZvSfezS5O7Stlw+KyWW4oxEQy3m
	ouJEAHIoRIoNAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi,

> Today's linux-next merge of the samsung tree got a conflict in
> arch/arm/boot/dts/exynos4210.dtsi between commit a7a8241540c3 ("ARM: dts:
> exynos4210-pinctrl: Add nodes for pin banks") from the pinctrl tree and
> commit 8d4155dbb184 ("ARM: EXYNOS: Add devicetree node for TMU driver for
> exynos4") from the samsung tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
Correct, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

