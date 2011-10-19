Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1JSFXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:23:14 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:42922
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007Ab1JSFXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:23:12 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 19 Oct 2011 13:33:55 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <patches@linaro.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, Rajendra Nayak <rnayak@ti.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <lrg@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111019053354.GB31162@S2100-06.ap.freescale.net>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111016145536.GA29885@S2100-06.ap.freescale.net>
 <4E9BAC4D.3010402@ti.com>
 <20111018115836.GC30703@S2100-06.ap.freescale.net>
 <20111018160046.GD28501@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111018160046.GD28501@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 05:00:46PM +0100, Mark Brown wrote:
> On Tue, Oct 18, 2011 at 07:58:37PM +0800, Shawn Guo wrote:
> 
> > I understand that ideally device tree is supposed to describe pure
> > hardware configurations.  But practically, when migrating a driver
> > to device tree probe, we are trying to move the configurations
> > described by platform_data into device tree to save the use of
> > platform_data for device tree probe.  Then some of the configuration
> > may not be so purely hardware related.  But I do not see this is a
> > critical problem.
> 
> It's not just Linux-specific stuff, some of this is even specific to
> what current Linux drivers can do - updating the kernel could mean a
> different set of constraints.
> 
Well, from what I see, the 'struct regulation_constraints' is defined
in machine.h and meant to be the regulator machine/board interface.
With the example I'm looking at, mc13892, the regulation_constraints
configuration is fully passed from machine/board file.  If there is
something specific to what drivers can do, it probably should be encoded
in regulator driver rather than staying in regulation_constraints.

So how do you think we should proceed here?

-- 
Regards,
Shawn

