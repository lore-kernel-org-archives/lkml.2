Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2LFAzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:55:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:2982 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2LFAz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:55:29 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Florian Fainelli <florian@openwrt.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Lin, JM" <JM.Lin@atmel.com>, "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [v2 PATCH 2/8] watchdog/at91sam9_wdt: Convert to use the
 watchdog framework
Thread-Topic: [v2 PATCH 2/8] watchdog/at91sam9_wdt: Convert to use the
 watchdog framework
Thread-Index: AQHN0olaD9JBif6wV0q1X7tzAJygsJgJgLSAgAFyEGA=
Date: Thu, 6 Dec 2012 00:54:48 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A01D599@penmbx01>
References: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
 <1354671267-19277-3-git-send-email-wenyou.yang@atmel.com>
 <3976223.KImVV2lC5B@flexo>
In-Reply-To: <3976223.KImVV2lC5B@flexo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB60tYOV017317

Hi Florian,

> -----Original Message-----
> From: Florian Fainelli [mailto:f.fainelli@gmail.com] On Behalf Of Florian Fainelli
> Sent: 2012å¹´12æœˆ5æ—¥ 18:48
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; Ferre, Nicolas; plagnioj@jcrosoft.com; Lin,
> JM; wim@iguana.be; linux-watchdog@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [v2 PATCH 2/8] watchdog/at91sam9_wdt: Convert to use the watchdog
> framework
> 
> Hello Wenyou,
> 
> On Wednesday 05 December 2012 09:34:21 Wenyou Yang wrote:
> > According to the kernel document: convert_drivers_to_kernel_api.txt,
> > remove the file_operations struct, miscdevice, and obsolete includes
> >
> > Since the at91sam watchdog inherent characteristics, add the watchdog
> > operations: at91wdt_start, at91wdt_stop and at91wdt_ping.
> >
> 
> [snip]
> 
> >
> > +static inline bool watchdog_is_open(struct watchdog_device *wddev)
> > +{
> > +	return test_bit(WDOG_DEV_OPEN, &wddev->status);
> > +}
> 
> This helper should be moved to include/linux/watchdog.h as it can be useful
> for other watchdog drivers as well.

Thanks, I will move it in next version.

> --
> Florian

Best Regards
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
