Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab2D0LPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 07:15:54 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:13490
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759841Ab2D0LPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 07:15:44 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 Apr 2012 19:24:57 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Zhao Richard-B20223 <B20223@freescale.com>
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120427112457.GG826@shlinux2.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120427085402.GV2234@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120427085402.GV2234@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:54:05PM +0800, Shawn Guo wrote:
> On Thu, Apr 26, 2012 at 10:40:25PM +0800, Dong Aisheng wrote:
> > +/**
> > + * struct imx_pin_reg - describe a pin reg map
> > + * The last 3 members are used for select input setting
> > + * @pid: pin id
> > + * @mux_reg: mux register offset
> > + * @conf_reg: config register offset
> > + * @mux_mode: mux mode
> > + * @input_reg: select input register offset for this mux if any
> > + *  0 if no select input setting needed.
> > + * @input_val: the value set to select input register
> > + */
> > +struct imx_pin_reg {
> > +	unsigned int pid;
> > +	unsigned int mux_reg;
> > +	unsigned int conf_reg;
> > +	unsigned int mux_mode;
> > +	unsigned int input_reg;
> > +	unsigned int input_val;
> > +};
> 
> Since the array of this struct is big, I would suggest define the type
> of the members as size-efficient as possible, for example, u16 is enough
> for pid, and reg offset, while u8 is enough for mux_mode?
> 
Yes, reasonable.
Will change to that in v4.

Regards
Dong Aisheng

