Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1F3Lkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:40:47 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:7372
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1F3Lkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:40:42 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz9371M542M1432N98dKzz1202hzzz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "grant@secretlab.ca" <grant@secretlab.ca>
Date: Thu, 30 Jun 2011 17:10:31 +0530
Subject: RE: [PATCH 02/11] GPIO: DA9052 GPIO module v1
Thread-Topic: [PATCH 02/11] GPIO: DA9052 GPIO module v1
Thread-Index: Acw26DOFy0nYiIvFQ6ytHGMNrhzvLAAMOoRw
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D152EB8925D@KCINPUNHJCMS01.kpit.com>
References: <1309355591.2344.4.camel@L-0532.kpit.com>
 <20110630053711.GB796@opensource.wolfsonmicro.com>
In-Reply-To: <20110630053711.GB796@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5UBetxg028378

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Thursday, June 30, 2011 11:07 AM
> To: Ashish Jangam
> Cc: jic23@cam.ac.uk; linux-kernel@vger.kernel.org; Dajun; grant@secretlab.ca
> Subject: Re: [PATCH 02/11] GPIO: DA9052 GPIO module v1
> 
> On Wed, Jun 29, 2011 at 07:23:11PM +0530, ashishj3 wrote:
> 
> > DA9052 PMIC has 16 bit GPIO bus for peripheral control.
> >
> > This patch add support for the GPIO pins on the DA9052.
> 
> > +	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
> > +	pdata = gpio->da9052->dev->platform_data;
> > +
> > +	if (pdata == NULL) {
> > +		dev_err(&pdev->dev, "Failed no platform data for GPIO\n");
> > +		ret = -ENOMEM;
> > +		goto err_mem;
> > +	}
> 
> Why insist on platform data?  gpiolib can dynamically allocate a GPIO
> range to the device.
Do you mean to use gpiochip_reserve() in machine file and not to have ngpio 
and base defined in GPIO platform driver but, this will fail the call to gpiochip_add()?
Can you elaborate on it?



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
