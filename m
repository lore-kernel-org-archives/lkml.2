Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2IDLtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:49:20 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:3607
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773Ab2IDLtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:49:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzzz2dh2a8h668h839h944hd25hf0ah107ah1220h1155h)
Date: Tue, 4 Sep 2012 19:27:04 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v5 3/4] regulator: anatop-regulator: convert to use
 syscon to access anatop register
Message-ID: <20120904112703.GA13046@shlinux2.ap.freescale.net>
References: <1346728811-25788-1-git-send-email-b29396@freescale.com>
 <1346728811-25788-4-git-send-email-b29396@freescale.com>
 <20120904113429.GK2362@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120904113429.GK2362@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 07:34:32PM +0800, Shawn Guo wrote:
> On Tue, Sep 04, 2012 at 11:20:10AM +0800, Dong Aisheng wrote:
> > +
> > +	anatop_np = of_get_parent(np);
> > +	if (!anatop_np)
> > +		return -ENODEV;
> > +	sreg->anatop = syscon_node_to_regmap(anatop_np);
> > +	if (IS_ERR(sreg->anatop))
> > +		return PTR_ERR(sreg->anatop);
> > +
> With of_node_put moved out from syscon_node_to_regmap, shouldn't
> we put anatop_np here then?
> 
When i sent it out, i found i missed it...
Should be more care...

Regards
Dong Aisheng

