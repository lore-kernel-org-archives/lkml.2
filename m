Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1KWTTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:19:47 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11493 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1KWTTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:19:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18WXXxozacfhFVm5rf4gLiI
Date: Wed, 23 Nov 2011 11:19:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <greg@kroah.com>, Mike Turquette <mturquette@linaro.org>,
        linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, jeremy.kerr@canonical.com,
        Mike Turquette <mturquette@ti.com>, sboyd@quicinc.com,
        magnus.damm@gmail.com, dsaxena@linaro.org,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org,
        patches@linaro.org, tglx@linutronix.de, linux-omap@vger.kernel.org,
        richard.zhao@linaro.org, shawn.guo@freescale.com, paul@pwsan.com,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, skannan@quicinc.com
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
Message-ID: <20111123191919.GH31337@atomide.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org>
 <20111122154900.GB18954@kroah.com>
 <CAPtuhThPQtWwihE8aGru55k87oV7QOr=O836TTJ+=30d6dtVhA@mail.gmail.com>
 <20111122191347.GB4844@kroah.com>
 <20111123165903.GF31337@atomide.com>
 <20111123180651.GB19739@n2100.arm.linux.org.uk>
 <20111123185518.GG31337@atomide.com>
 <20111123190954.GA4365@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123190954.GA4365@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@opensource.wolfsonmicro.com> [111123 10:34]:
> On Wed, Nov 23, 2011 at 10:55:19AM -0800, Tony Lindgren wrote:
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [111123 09:31]:
> 
> > > Keep the clk API as a fundamental thing which should be initialized early
> > > so we don't have to invent new clk APIs to get around its unavailability.
> 
> > What else are you aware of that is really needed early for clocks other
> > than clockevent?
> 
> If nothing else we'd have to resolve all the device probe ordering
> issues (Grant's patches seem a bit stalled) and convert all the systems
> using the API to handle deferring probes until their clocks appear.
> Using an early initcall of some kind would help with that but it does
> seem like a lot of trouble and I'd expect it'll end up getting forced in
> on most systems anyway.

Yes the ordering depends on the system. In any case, initcalls are
not super early compared to setup_timer.

Tony
