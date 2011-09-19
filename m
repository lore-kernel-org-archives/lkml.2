Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1ISLRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 07:17:15 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:9647
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab1ISLRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 07:17:13 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K542M1432N98dKc1dMzz1202hzzz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC02.kpit.com;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: RE: LKML - Battery charge current issue
Thread-Topic: LKML - Battery charge current issue
Thread-Index: AQHMdraJOnOhY2juB0aX/BzGxFQTm5VUhDDg
Date: Mon, 19 Sep 2011 11:15:13 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED0212D4@KCHJEXMB01.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED021260@KCHJEXMB01.kpit.com>
 <20110919102548.GA4175@opensource.wolfsonmicro.com>
In-Reply-To: <20110919102548.GA4175@opensource.wolfsonmicro.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8JBHLOf014443


> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Monday, September 19, 2011 3:56 PM
> To: Ashish Jangam
> Subject: Re: LKML - Battery charge current issue
> 
> On Mon, Sep 19, 2011 at 06:26:10AM +0000, Ashish Jangam wrote:
> 
> Questions like this should always be CCed to the list.
> 
> > Some Power Management Controllers has a feature of configuring battery
> > charge current for faster battery charging.
> 
> > In the Linux power supply core there is no provision that can help the user
> > for configuring battery charge current at "runtime". In current Linux
> implementation
> > this is done in battery "probe" probably using platform data.
> 
> > Should an additional entry in sysfs be added for configuring battery charge
> current
> > since most of our clients desire such feature?
> 
> This depends what you're looking to do.  The specific currents used
> should be configured using platform data, if the user gets these wrong
> they can result in physical damage to the system so it's generally
> undesirable to have userspace poking at them.  The switch from trickle
> to fast charge is normally managed automatically, often by hardware.
> If there's absolutely no way to figure this out from kernel I guess a
> userspace control would be OK but it'd be pretty surprising.

Hardware that don't support/have automatic upgrade then, quick battery charge feature
will be of no use to end user and especially in smart phone this could be problematic.

If sysfs is not a good way of doing this then some alternate mechanism will be very much
appreciated. 


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
