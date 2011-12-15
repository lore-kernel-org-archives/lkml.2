Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1LOI4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:56:01 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:40512 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab1LOIz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:55:58 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Topic: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Thread-Index: AQHMunirzWtXRBa0wUCO2ofliTlfR5XcOaMAgAAR44CAACoQYIAAgTkA//+ikvA=
Date: Thu, 15 Dec 2011 08:55:54 +0000
Message-ID: <7FE21149F4667147B645348EC6057885056487@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-5-git-send-email-b29396@freescale.com>
	<20111214211152.GM27267@pengutronix.de>
	<CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
	<7FE21149F4667147B645348EC60578850561FF@039-SN2MPN1-013.039d.mgd.msft.net>
 <CACRpkda-hzrgQ7YttN3Vi3E6jTv-LaQDyAqyJjdvqYDL+C50XA@mail.gmail.com>
In-Reply-To: <CACRpkda-hzrgQ7YttN3Vi3E6jTv-LaQDyAqyJjdvqYDL+C50XA@mail.gmail.com>
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
> Sent: Thursday, December 15, 2011 4:29 PM
> To: Dong Aisheng-B29396
> Cc: Sascha Hauer; linus.walleij@stericsson.com; linux-
> kernel@vger.kernel.org; rob.herring@calxeda.com;
> grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; Guo Shawn-R65073
> Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux
> subsystem
> Importance: High
> 
> On Thu, Dec 15, 2011 at 8:23 AM, Dong Aisheng-B29396
> <B29396@freescale.com> wrote:
> > [Me]
> >> So if you want to do this for i.MX you need something like selectable
> >> dummy pinmuxes, i.e. pinmux_get() to return something that just say
> "OK"
> >> to everything like the dummy regulators.
> >>
> >> Shall I try to create something like that?
> >
> > For those platforms do not select PINCTRL, current code does not block.
> 
> Yeah I know...
> 
> > For platforms do select PINCTRL but does not have pinmux driver ready,
> > for example, single image for both mx5&mx6, IMHO it may be better to
> > fix in driver to avoid introduce too much complexity in pinctrl core.
> 
> If you mean that you fix the i.MX driver for all the combines i.MX
> variants then I agree.
> 
Yes, I mean this one.

> If you mean to do stuff like allow the code to continue even if the
> pinmux isn't found - no. That is not the way we proceed with clocks and
> regulators as Mark has taught me recently, so for consistency we need to
> error out if no pinmux is found.
> 

Regards
Dong Aisheng


