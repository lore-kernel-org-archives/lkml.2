Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1LGJSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:18:46 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:48598
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab1LGJSl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:18:41 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH 3/3] pinctrl: imx: add pinmux-imx6q support
Thread-Topic: [RFC PATCH 3/3] pinctrl: imx: add pinmux-imx6q support
Thread-Index: AQHMsnlmt2gm/uAHMEandVQq7X9Y4JXOz4aA//+a+jCAAhUBAP//m+NA
Date: Wed, 7 Dec 2011 09:18:36 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F77234FC5B@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-3-git-send-email-b29396@freescale.com>
	<20111206072326.GA3712@S2100-06.ap.freescale.net>
	<65EE16ACC360FA4D99C96DC085B3F772345A0B@039-SN1MPN1-002.039d.mgd.msft.net>
 <CACRpkdbVXkpVHqhP2SHV2fud66NYFj0mcAPyaqJoyUS-20to5Q@mail.gmail.com>
In-Reply-To: <CACRpkdbVXkpVHqhP2SHV2fud66NYFj0mcAPyaqJoyUS-20to5Q@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Wednesday, December 07, 2011 5:10 PM
> To: Dong Aisheng-B29396; Guo Shawn-R65073
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> kernel@pengutronix.de
> Subject: Re: [RFC PATCH 3/3] pinctrl: imx: add pinmux-imx6q support
> 
> On Tue, Dec 6, 2011 at 8:23 AM, Dong Aisheng-B29396 <B29396@freescale.com>
> wrote:
> >> From: Guo Shawn-R65073
> >> As I do not see the device tree probing added in pinmux-imx-core.c, I
> >> expect the patch has not got the chance to run on imx6, right?
> >>
> > Yes, I would add it if the pinctrl framework supports DT.
> 
> There are many levels of DT.
> 
> You can of course add DT-support for anything driver-specific, such as
> init data for some registers, or anything else you would normally pass in
> through platform data. So please just do that if imx6 already has support
> for such things.
> 
> What we're discussing about right now on devicetree-discuss is where to
> put the mapping tables etc that is currently registered by the board,
> that has no obvious solution as there is some disagreement on how to do
> that.
> 
Yes, thanks for your info.
I'm new to device tree and may take some time to get more familiar with it.

I discussed with Shawn today and now we're going to move data to dt and run
this driver on mx6q first.

Regards
Dong Aisheng

