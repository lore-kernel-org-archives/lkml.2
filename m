Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2HFCPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:15:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8482 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2HFCPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:15:19 -0400
X-AuditID: cbfee612-b7f2d6d0000007ea-eb-501f28b5cb24
Date: Mon, 06 Aug 2012 02:15:17 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] Extcon: adc_jack: adc-jack driver to support 3.5 pi or
 simliar devices
To: Anish Kumar <anish198519851985@gmail.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        ANISH KUMAR <anish.singh@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120806021140534@myungjoo.ham
Msgkey: 20120806021140534@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120806021140534@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29824246.53241344219316571.JavaMail.weblogic@epml13>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t/tGbpbNeQDDJZNNLa4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZc+dfYivYx1bx4d5btgbGJWxdjJwcQgLqEouWnASzJQRMJKbf
	6mKGsMUkLtxbDxTnAqqZzyixetNbRpAEi4CKxMStE4FsDg42AXOJ+zOCQMLCAtESuyZ9ZwWp
	FxGYzCjxan0rC4jDLLCcUeLTk2PsENuUJNbse8UCYvMKCEqcnPmEBWKbqsSNzn+sEHE1ie8T
	LkFdISExa/oFVgibV2JG+1OoejmJaV/XQNVIS5yftYER5urF3x9Dxfkljt3ewQRyKEjvk/vB
	MGN2b/4C9bCAxNQzB6FatSRe3lkKFeeTWLPwLQvMmF2nljPD9N7fMpcJxGYWUJSY0v2QHcLW
	kvjyYx8burd4BRwlXrydzzyBUW4WktQsJO2zkLQjq1nAyLKKUTS1ILmgOCk91UKvODG3uDQv
	XS85P3cTIzjSnwntYFzWYHGIUYCDUYmHt3OfbIAQa2JZcWXuIUYJDmYlEd50Z7kAId6UxMqq
	1KL8+KLSnNTiQ4zSHCxK4rxzXnzxFxJITyxJzU5NLUgtgskycXBKNTCKdiyYK8Z3NvD3j4c8
	Zxxu1K3lSN20IMOlWvWZtNyJpd81ZL5EbXiYXcE/ZaX64qhQwa1b38+tyTFmeHTcVe/Pl5MJ
	mct3uNyN3xf84hejp4VnbInXMu71la25C7lYZH7r8l++ZX1/XVfWjGfc63f8MOq3L7Zvv+nI
	yxChHSu8Zp5nacaJam8lluKMREMt5qLiRABNiBt38AIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q762FQeM002902

> From: anish kumar <anish198519851985@gmail.com>
> 
> External connector devices that decides connection information based on
> ADC values may use adc-jack device driver. The user simply needs to
> provide a table of adc range and connection states. Then, extcon
> framework will automatically notify others.
> 
> Signed-off-by: anish kumar <anish.singh@samsung.com>

- Please remove "get_adc" callbacks still remaining in the header file
(and its comments)

- Let's not modify un-related driver code (in Kconfig, extcon-gpio)

Except that, things look good.


Cheers
MyungJoo


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
