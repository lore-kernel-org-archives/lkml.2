Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0K3Blz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:41:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:50899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab0K3Bly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:41:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,277,1288594800"; 
   d="scan'208";a="631436644"
From: "Wang, Qi" <qi.wang@intel.com>
To: Ben Dooks <ben-i2c@fluff.org>, Jean Delvare <khali@linux-fr.org>
CC: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Nov 2010 09:39:55 +0800
Subject: RE: [PATCH] EG20T: Update PCH_I2C driver to 2.6.36
Thread-Topic: [PATCH] EG20T: Update PCH_I2C driver to 2.6.36
Thread-Index: Act/85YniqZTwg7DR8WBV99VInEwTwQO7W6w
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A303B28AB@shsmsx501.ccr.corp.intel.com>
References: <4CD8CD32.5000909@dsn.okisemi.com>
 <D5AB6E638E5A3E4B8F4406B113A5A19A3012F51E@shsmsx501.ccr.corp.intel.com>
 <20101109092944.0670d428@endymion.delvare>
 <20101109095012.GA21564@trinity.fluff.org>
In-Reply-To: <20101109095012.GA21564@trinity.fluff.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAU1g5IG009528

Hi Ben,

Need your help to review this patch. We're eager to see when this patch will be accepted by the upstream.

Best Regards,
Qi.



> -----Original Message-----
> From: Ben Dooks [mailto:ben-i2c@fluff.org]
> Sent: Tuesday, November 09, 2010 5:50 PM
> To: Jean Delvare
> Cc: Wang, Qi; Ben Dooks (embedded platforms); Khor, Andrew Chih Howe;
> Wang, Yong Y; Ewe, Kok Howg; Tomoya MORINAGA; Samuel Ortiz; Linus Walleij;
> Wolfram Sang; Ralf Baechle; srinidhi kasagar; linux-i2c@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] EG20T: Update PCH_I2C driver to 2.6.36
> 
> I'll have a look at this
> 
> --
> Ben
> 
> Q:      What's a light-year?
> A:      One-third less calories than a regular year.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
