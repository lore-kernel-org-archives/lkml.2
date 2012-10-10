Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2JJGwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:52:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44977 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2JJGw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:52:29 -0400
X-AuditID: cbfee60b-b7fe86d000000e89-7e-50751b28df7e
Date: Wed, 10 Oct 2012 06:52:24 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon : register for cable interest by cable name
To: Jenny TC <jenny.tc@intel.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: myungjoo.ham@gmail.com
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121010063129865@myungjoo.ham
Msgkey: 20121010063129865@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121010063129865@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <7103095.833841349851943826.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/tGboa0qUBBit3K1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mszu8C25wVVyZ8IypgXEDVxcjJ4eQgLrEoiUn2boYOTgkBEwk
	9h9kBAlLCIhJXLi3HijMBVQyn1Fi74sVTCAJFgFViQW32xhB6tkE9CRmfk4GCQsLuEtMmtPJ
	AlIvIrCQUWLRwfWsIAlmAXmJDzuusEHsUpJYs+8VC4jNKyAocXLmExaIZaoSLU232CDiahKr
	5kyFiktIzJp+gRXC5pWY0f4UKi4nMe3rGmYIW1ri/KwNcEcv/v4YKs4vcez2DiaIv3glntwP
	hhmze/MXNghbQGLqmYOMECVaEncfcUCE+STWLHzLAjNl16nlzDCt97fMZYL4SlFiSvdDdghb
	S+LLj31s6L7iFXCU2LHlEfsERrlZSFKzkLTPQtKOrGYBI8sqRtHUguSC4qT0VEO94sTc4tK8
	dL3k/NxNjOAIf8a9g3FWg8UhRgEORiUe3oyokgAh1sSy4srcQ4wSHMxKIrwyK4FCvCmJlVWp
	RfnxRaU5qcWHGKU5WJTEees8UgKEBNITS1KzU1MLUotgskwcnFINjJMeHrfYwnS4zrh5/uz2
	Zq0nM44yPBf6LFRR8CvsgoGk9E+Fm8Y853arLD8jssj55aU2z7efAt51S5xaXsBgevX4nYhJ
	axKvVJVk/4iPuWa8pUSp0G1P94UHTgUPRD/K/7XYdb3vGffZ0E3CGemzbr1ICXK1X/xR89yD
	iMx5L9wkJaYEPbta0qzEUpyRaKjFXFScCABSMj+L7AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9A6qf8B010122

> There are some scnearios where a driver/framework needs to register
> interest for a particular cable without specifying the extcon device
> name. One such scenario is charger notifications. The platform will
> have charger cabel which will be bound to any extcon device. It's
> not mandatory for the charger driver to know which extcon device
> it should use. This patch enables the support for registering
> interest for a cable just by cable name wihtout specifying the
> extcon device name
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
[]
> +extern struct extcon_dev *register_interest_cable_byname
> +		(struct extcon_specific_cable_nb *extcon_dev,
> +		const char *cable_name, struct notifier_block *nb);

What about allowing extcon_register_interest() to support the functionality?

I.e., allowing extcon_register_interest() to accept NULL extcon_name.


ps. anyway, usually, the "platforms" have the list of node paths, don't they?

Cheers!
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
