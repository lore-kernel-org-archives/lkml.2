Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1LOG1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:27:23 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5628 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab1LOG1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:27:19 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 0,
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Dajun Chen <dchen@diasemi.com>
Subject: RE: linux-next: build failure after merge of the regmap tree
Thread-Topic: linux-next: build failure after merge of the regmap tree
Thread-Index: AQHMuvFJBFajYHNTuE6ZKBNQiG+z65Xcbhgg
Date: Thu, 15 Dec 2011 06:24:44 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1F9D0855@KCHJEXMB01.kpit.com>
References: <20111215170517.0b7fc08487881743ca76c192@canb.auug.org.au>
 <20111215061757.GC24287@sirena.org.uk>
In-Reply-To: <20111215061757.GC24287@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.22]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBF6RUXT007067

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Thursday, December 15, 2011 11:48 AM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Ashish
> Jangam; Grant Likely; David Dajun Chen
> Subject: Re: linux-next: build failure after merge of the regmap tree
> 
> On Thu, Dec 15, 2011 at 05:05:17PM +1100, Stephen Rothwell wrote:
> 
> > drivers/gpio/gpio-da9052.c:25:35: fatal error: linux/mfd/da9052/gpio.h:
> No such file or directory
> 
> > So, it looks like this would never have built
> > (include/linux/mfd/da9052/gpio.h never existed) but noone ever enabled
> > CONFIG_PMIC_DA9052 before (which CONFIG_GPIO_DA9052 depends on).
> 
> > drivers/gpio/gpio-da9052.c was added with commit 07bfc9152365 ("GPIO:
> > DA9052 GPIO module v3") in v3.1-rc1.
> 
> The issue here is that the GPIO driver was merged prior to review being
> completed for the MFD and then problems with the MFD caused lots of
> changes in the rest of the series.  The MFD review is now fine so it's
> been merged (via regmap due to use of new regmap features) but the GPIO
> driver needs updating.
> 
> Ashish or Daneil, could you please send a patch fixing this?  Possibly
> just a case of adding the new header.
I have a fix for this issue will just take an incremental patch and post it.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
