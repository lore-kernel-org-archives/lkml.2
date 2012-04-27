Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2D0HHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:07:31 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:33617
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab2D0HHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:07:30 -0400
X-SpamScore: -11
X-BigFish: VS-11(zcb8kz154dM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 Apr 2012 15:16:55 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Zhao Richard-B20223 <B20223@freescale.com>
Subject: Re: [PATCH v3 3/4] pinctrl: pinctrl-imx: add imx6q pinctrl driver
Message-ID: <20120427071654.GB826@shlinux2.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-3-git-send-email-b29396@freescale.com>
 <20120427064519.GO17184@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120427064519.GO17184@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 02:45:19PM +0800, Sascha Hauer wrote:
> On Thu, Apr 26, 2012 at 10:40:26PM +0800, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> > ChangeLog v1-v2:
> > * add binding doc for pinctrl-imx6q
> > * refactor the probe
> > ---
> >  .../bindings/pinctrl/fsl,imx6q-pinctrl.txt         | 1605 ++++++++++++++
> >  drivers/pinctrl/Kconfig                            |    8 +
> >  drivers/pinctrl/Makefile                           |    1 +
> >  drivers/pinctrl/pinctrl-imx6q.c                    | 2331 ++++++++++++++++++++
> >  4 files changed, 3945 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
> >  create mode 100644 drivers/pinctrl/pinctrl-imx6q.c
> > 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
> > new file mode 100644
> > index 0000000..13d474f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
> > @@ -0,0 +1,1605 @@
> > +* Freescale IMX6Q IOMUX Controller
> > +
> > +Please refer to fsl,imx-pinctrl.txt in this directory for common binding part
> > +and usage.
> > +
> > +Required properties:
> > +- compatible: "fsl,imx6q-iomuxc"
> > +- fsl,pins: two integers array, represents a group of pins mux and config
> > +  setting. The format is fsl,pins = <PIN_FUNC_ID CONFIG>, PIN_FUNC_ID is a
> > +  pin working on a specific function, CONFIG is the pad setting value like
> > +  pull-up for this pin. Please refer to imx6q datasheet for the valid pad
> > +  config settings.
> 
> Wouldn't it make sense to document the CONFIG bits here? Something like
> 
> Pull keeper enabled (pke)	(1 << 7)
> ...
> 
Yes, it makes sense for me to add it.

> Not all bits are available on all pins, refer to the datasheet...
> 

Regards
Dong Aisheng

