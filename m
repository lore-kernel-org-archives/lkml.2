Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1EIKdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:33:17 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:24540
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808Ab1EIKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:33:15 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz9371O542M1432N98dKzz1202hzz8275bhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.Kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Date: Mon, 9 May 2011 16:02:18 +0530
Subject: RE: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
Thread-Index: AcwLLQwIoUpi66IDSPCh/HPndzt5ngC9RY1Q
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BB713D4@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8D9@KCINPUNHJCMS01.kpit.com>
 <20110504135833.c44c372d.akpm@linux-foundation.org>
 <20110505140238.GB26651@sirena.org.uk>
In-Reply-To: <20110505140238.GB26651@sirena.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p49AXQAu024203

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Thursday, May 05, 2011 7:33 PM
> To: Andrew Morton
> Cc: Ashish Jangam; Lars-Peter Clausen; rpurdie@rpsys.net; linux-
> kernel@vger.kernel.org; David Dajun Chen
> Subject: Re: [PATCHv1 -next] LEDS: LED module of DA9052 PMIC driver
> 
> On Wed, May 04, 2011 at 01:58:33PM -0700, Andrew Morton wrote:
> > Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:
> 
> > > LED Driver for Dialog Semiconductor DA9052 PMICs.
> 
> > I don't know what to do with this patch.
> 
> > > +	depends on PMIC_DA9052
> 
> > Because it is unusable as a standalone patch.
> 
> > What is your merge plan for PMIC_DA9052 support?  Please work one out,
> > and tell us about it in each and every patch so that the people who are
> > receiving these emails can work out what to do with them.
> 
> Ideally you should do this by submitting all your patches in a single
> patch series.
LED module is dependent upon MFD module so does this mean that along with the LED patch we also need to give MFD patch as reference or just list down the dependent module in the LED patch. 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
