Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab1LFDno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:43:44 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:26571
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606Ab1LFDnn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:43:43 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Topic: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Index: AQHMsnlAdrguC9Qi5Ei/Yb1CNiu/O5XNneYAgACOr8A=
Date: Tue, 6 Dec 2011 03:41:13 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7723457F0@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <CACRpkdaayt=VuUz2XrkYgGJWFzW3hwJZDP+vHWTf9vLYRY4q5w@mail.gmail.com>
In-Reply-To: <CACRpkdaayt=VuUz2XrkYgGJWFzW3hwJZDP+vHWTf9vLYRY4q5w@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Monday, December 05, 2011 9:10 PM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de; Guo Shawn-R65073;
> kernel@pengutronix.de
> Subject: Re: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
> 
> On Sun, Dec 4, 2011 at 12:49 PM, Dong Aisheng <b29396@freescale.com>
> wrote:
> 
> > ---
> > This patch series shows the basic idea of driver design. There're
> > still some TODOes like adding more pinmux functions and gpio support.
> > The patch is here for request for comments on the driver design and
> > other might exist issues.
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Shawn Guo <shanw.guo@freescale.com>
> 
> Dong, this is looking real good from pinctrl subsystem point of view.
> 

It's good if it's ok.
Thanks for your review.

Regards
Dong Aisheng


