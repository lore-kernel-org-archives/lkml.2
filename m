Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1GELhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:37:18 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:33265
	"EHLO CH1EHSOBE017.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932242Ab1GELhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:37:16 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz9371M542M154dM1432N98dKzz1202hzz8275bh8275dhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Date: Tue, 5 Jul 2011 17:07:06 +0530
Subject: RE: [PATCH 1/11] MFD: DA9052 MFD core module v1
Thread-Topic: [PATCH 1/11] MFD: DA9052 MFD core module v1
Thread-Index: Acw2V+21TU4PuLHpRr+zto4T2nWgKQErmZAA
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D18F6DB1B06@KCINPUNHJCMS01.kpit.com>
References: <1309270609.376.226.camel@L-0532.kpit.com>
 <201106291427.11534.arnd@arndb.de>
In-Reply-To: <201106291427.11534.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p65BbQ0p015674

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, June 29, 2011 5:57 PM
> To: Ashish Jangam
> Cc: Mark Brown; sameo@openedhand.com; linux-kernel@vger.kernel.org; Dajun;
> linaro-dev@lists.linaro.org
> Subject: Re: [PATCH 1/11] MFD: DA9052 MFD core module v1
> 
> On Tuesday 28 June 2011, ashishj3 wrote:
> > The DA9052 is a highly integrated PMIC subsystem with supply domain
> flexibility
> > to support wide range of high performance application.
> >
> > It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> > control and other functionality.
> >
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> 
> Hi Ashish and Dajun,
> 
> As we discussed last time, I think it would be important to lay out the
> drivers in a way that also works with the da9053 chip that has recently
> been submitted in another thread.
> 
> This does not mean that you have to support both from the start, but
> I would expect you to look at the differences and for each file decide
> whether they are completely different (e.g. one of them has backlight,
> the other one doesn't) or similar enough to be handled by one driver
> with a few conditional functions. My guess is that the da9052-core.c
> file would be different for each chip, while both the front-end
> (spi, i2c) and the back-end drivers (hwmon, backlight, regulator, ...)
> can be shared.
> 
> Please rename the files and the identifiers accordingly, and document
> in the changelog which hardware they can eventually support.
> I would expect a lot of the identfiers to become da905x or even
> da90xx.
DA9053 chip submission was done by Linaro and now they have agreed that
we will be only responsible for DA9053 submission too so now we can
skip the posted DA9053 patch.

Regarding file naming convention da9052 seems to be appropriate since 
DA9053 chip is update of DA9052 and also DA9052 is the umbrella name
for the whole family.

Ashish


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
