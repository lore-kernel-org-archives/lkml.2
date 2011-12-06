Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1LFDmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:42:17 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:11105
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932881Ab1LFDmP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:42:15 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Thread-Topic: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
Thread-Index: AQHMsnlB4tyTDOR3uEmPDrmj3tcvppXMPl6AgAGgQACAAE5AcA==
Date: Tue, 6 Dec 2011 03:42:11 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7723457FD@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-2-git-send-email-b29396@freescale.com>
	<20111204161123.GS27267@pengutronix.de>
 <CACRpkdZ0aNj-BsdtD2R-bEWQfMzsOMNbdh6ryVtgwET3Ry7xXA@mail.gmail.com>
In-Reply-To: <CACRpkdZ0aNj-BsdtD2R-bEWQfMzsOMNbdh6ryVtgwET3Ry7xXA@mail.gmail.com>
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
> Sent: Tuesday, December 06, 2011 1:01 AM
> To: Sascha Hauer
> Cc: Dong Aisheng-B29396; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linus.walleij@stericsson.com; Guo Shawn-
> R65073; kernel@pengutronix.de
> Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
> 
> On Sun, Dec 4, 2011 at 5:11 PM, Sascha Hauer <s.hauer@pengutronix.de>
> wrote:
> 
> > I don't think that this grouping of pads to their functions makes
> > sense. On i.MX every pad is muxed independently and not in groups.
> > Which pins belong to which function is board specific and not SoC
> > specific.
> 
> True, Dong can this be moved to the imx pinctrl platform data and passed
> in from arch/arm/[plat|mach]-* board files instead?
> That is probably where it belongs today.
> 
Yes, I will do that.

> I know that this data is in drivers/pinctrl for the U300 and SIRF, but
> that is because they only have one single board variant.
> 
> Yours,
> Linus Walleij

Regards
Dong Aisheng

