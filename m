Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2HXCtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:49:14 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18711 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab2HXCtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:49:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzzz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Fri, 24 Aug 2012 10:29:47 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>, Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH 4/7] regulator: anatop-regulator: convert to use
 imx-syscon to access anatop register
Message-ID: <20120824022946.GB5822@shlinux2.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-5-git-send-email-b29396@freescale.com>
 <20120822155953.GQ7995@opensource.wolfsonmicro.com>
 <20120823071503.GF10057@shlinux2.ap.freescale.net>
 <20120823111741.GX7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120823111741.GX7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 07:17:41PM +0800, Mark Brown wrote:
> On Thu, Aug 23, 2012 at 03:15:04PM +0800, Dong Aisheng wrote:
> > On Wed, Aug 22, 2012 at 11:59:53PM +0800, Mark Brown wrote:
> 
> > > With the conversion to regmap it'd also be good to convert the driver to
> > > use the regmap helper functions for enable and voltage operations if
> > > possible.
> 
> > The anatop-regulator driver only implements set_voltage_sel/get_voltage_sel
> > which i have already converted, what do you mean others like
> > 'for enable and voltage operations' i should also convert?
> 
> Those operations should ideally be converted to use the generic regmap
> implementation now the device uses regmap - regmap_get_voltage_sel_regmap
> and so on.

Okay, got it.

Regards
Dong Aisheng

