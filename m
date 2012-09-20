Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2ITXTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:19:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34507 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab2ITXTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:19:22 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] power_supply: add new lp8788 charger driver
Thread-Topic: [PATCH v4] power_supply: add new lp8788 charger driver
Thread-Index: AQHNl33+s01O5KgSDUijJYDBAHfx45eT2rbQ
Date: Thu, 20 Sep 2012 23:19:07 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF5B1C@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF2227@DQHE02.ent.ti.com>
 <20120920221638.GF18223@lizard>
In-Reply-To: <20120920221638.GF18223@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8KNJwwd007179

> -----Original Message-----
> From: Anton Vorontsov [mailto:anton.vorontsov@linaro.org]
> Sent: Friday, September 21, 2012 7:17 AM
> To: Kim, Milo
> Cc: David Woodhouse; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v4] power_supply: add new lp8788 charger driver
> 
> On Wed, Sep 05, 2012 at 10:43:21AM +0000, Kim, Milo wrote:
> >  TI LP8788 PMU supports regulators, battery charger, RTC,
> >  ADC, backlight driver and current sinks.
> >
> >  This patch supports the charger operations including
> >  the charger interrupt handling.
> [...]
> > Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> > ---
> 
> Had to fix a bunch of checkpatch complaints:
> 
> CHECK: space prohibited before semicolon
> #478: FILE: drivers/power/lp8788-charger.c:396:
> +       for (i = 0 ; i < pdata->num_chg_params ; i++) {
> 
> CHECK: space prohibited before semicolon
> #541: FILE: drivers/power/lp8788-charger.c:459:
> +       for (i = 0 ; i < pchg->num_irqs ; i++) {

Thanks a lot for this review.

It seems like the result of running checkpatch script with --strict option.
Should I keep this option whenever submitting the file?
I used to run w/o strict option.

> 
> 
> But other than this, it looks really good, this is now applied.
> 
> Obviously, I couldn't compile-test it, but hopefully it will work
> once MFD part is also in. :-) If not, you can just send a follow-up
> fix.

Additionally, lp8788-charger depends on lp8788-adc driver.
I've found wrong calculation on getting the battery voltage and temperature.
I would submit this patch later.

I appreciate your help.

Best Regards,
Milo

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
