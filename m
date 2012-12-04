Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab2LDDQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 22:16:22 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:28084 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LDDQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 22:16:20 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "Lin, JM" <JM.Lin@atmel.com>
Subject: RE: [PATCH 00/11] watchdog/at91sam9_wdt: use watchdog framework,
 support DT
Thread-Topic: [PATCH 00/11] watchdog/at91sam9_wdt: use watchdog framework,
 support DT
Thread-Index: AQHNxAGpskznYGdGQU+VpqTPoKwQHZgIEfDg
Date: Tue, 4 Dec 2012 03:12:06 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A01CE70@penmbx01>
References: <1352877369-19740-1-git-send-email-wenyou.yang@atmel.com>
 <20121116135043.GI4398@game.jcrosoft.org>
In-Reply-To: <20121116135043.GI4398@game.jcrosoft.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB43GM6t006705

Hi JC
> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> Sent: 2012Äê11ÔÂ16ÈÕ 21:51
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; wim@iguana.be;
> linux-watchdog@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre, Nicolas; Lin,
> JM
> Subject: Re: [PATCH 00/11] watchdog/at91sam9_wdt: use watchdog framework,
> support DT
> 
> On 15:15 Wed 14 Nov     , Wenyou Yang wrote:
> > Hi, All
> >
> > The patch series is intended to convert to use the watchdog framework,
> > and add support to device tree.
> > It has been tested on sam9m10g45ek, sam9g20ek, sam9263ek and sam9g25ek.
> you need to check Fabio wrok which is present on the ML for a while and  was
> reviewed and binding too
>
OK, I will do it, thanks.
 
> Best Regards,
> J.
> >
> > It is based on v3.7-rc5.
> >
> > Best Regards
> > Wenyou Yang
> >

Best Regards
Wenyou Yang

> > Wenyou Yang (11):
> >   watchdog/at91sam9_wdt: remove the file_operations struct
> >   watchdog/at91sam9_wdt: change the at91wdt_private struct to the
> >     at91wdt_drvdata struct
> >   watchdog/at91sam9_wdt: change the wdt_read and wdt_write macro to the
> >     inline function
> >   watchdog/at91sam9_wdt: change "at91_wdt_settimeout" function name to
> >     "at91wdt_enable"
> >   watchdog/at91sam9_wdt: add to use the watchdog framework
> >   watchdog/at91sam9_wdt: change the timer function name
> >   watchdog/at91sam9_wdt: add nowayout helpers to Watchdog Timer Driver
> >     Kernel API
> >   watchdog/at91sam9_wdt: use module_platform_driver()
> >   watchdog/at91sam9_wdt: add support to device tree
> >   watchdog/at91sam9_wdt: using dev_info replaces pr_info, dev_crit
> >     repalces pr_crit
> >   ARM: dts: add the watchdog nodes for atmel SoC
> >
> >  .../devicetree/bindings/watchdog/atmel-wdt.txt     |   14 +
> >  arch/arm/boot/dts/at91sam9260.dtsi                 |    6 +
> >  arch/arm/boot/dts/at91sam9263.dtsi                 |    6 +
> >  arch/arm/boot/dts/at91sam9263ek.dts                |    4 +
> >  arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |    4 +
> >  arch/arm/boot/dts/at91sam9g25ek.dts                |    4 +
> >  arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
> >  arch/arm/boot/dts/at91sam9m10g45ek.dts             |    4 +
> >  arch/arm/boot/dts/at91sam9n12.dtsi                 |    6 +
> >  arch/arm/boot/dts/at91sam9n12ek.dts                |    4 +
> >  arch/arm/boot/dts/at91sam9x5.dtsi                  |    6 +
> >  drivers/watchdog/Kconfig                           |    1 +
> >  drivers/watchdog/at91sam9_wdt.c                    |  294 ++++++++------------
> >  13 files changed, 185 insertions(+), 173 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> >
> > --
> > 1.7.9.5
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
