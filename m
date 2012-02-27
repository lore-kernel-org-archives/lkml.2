Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2B0XK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:10:56 -0500
Received: from be1ssnxpe2.nxp.com ([57.67.164.70]:54417 "EHLO
	be1ssnxpe2.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2B0XKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:10:55 -0500
From: Kevin Wells <kevin.wells@nxp.com>
To: Roland Stigge <stigge@antcom.de>, Wolfram Sang <w.sang@pengutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Tue, 28 Feb 2012 00:10:38 +0100
Subject: RE: [PATCH v3] ARM: LPC32xx: Ethernet support
Thread-Topic: [PATCH v3] ARM: LPC32xx: Ethernet support
Thread-Index: Acz1m8E/vjWRueyVR3ir9PUA4VCgbQAApCQw
Message-ID: <083DF309106F364B939360100EC290F81F365B2B2A@eu1rdcrdc1wx030.exi.nxp.com>
References: <1330364762-23203-1-git-send-email-stigge@antcom.de>
 <20120227180814.GB21386@pengutronix.de> <4F4BFDD2.8060007@antcom.de>
In-Reply-To: <4F4BFDD2.8060007@antcom.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-02-27_06:2012-02-27,2012-02-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1RNB1aD021587

>>> This patch adds ethernet support to the LPC32xx ARM architecture.
>>> The actual driver in drivers/net is contained in a separate
>>> patch.
>>> 
>>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>> 
>>> ---
>> 
>> Please add below this dashed line what changed since the last
>> version. This makes reviewing easier. 
>
>OK, will do next time.
>
>For the driver, some style fixes were applied, and the cmdline
>"ethaddr" was removed, relying on the bootloader to set it correctly
> (and it actually does, it actually needs to prepare TFTP booting).

I'm not sure I'd trust the bootloader to always set the MAC address
in hardware prior to calling the kernel. A lot of u-boot MAC drivers,
including the 32x0's, only set the MAC address on the call to
eth_init(), which is only called when the network interface is used.
If you do a MTD based kernel boot, the MAC address will probably be
invalid if you try to do a NFS mount for the filesystem.

>The platform-support patch just adjusted to the small driver change:
>driver name adjustment ("lpc-eth") for consistency.
>
>Roland
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
