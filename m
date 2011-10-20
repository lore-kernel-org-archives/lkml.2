Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab1JTWJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 18:09:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28039 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713Ab1JTWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 18:09:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/9GEebB1EWZJoXsvp/+Qdg
Date: Thu, 20 Oct 2011 15:09:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111020220914.GP3842@atomide.com>
References: <20111019151031.GA4275@opensource.wolfsonmicro.com>
 <4E9F9892.9070007@ti.com>
 <20111020094140.GK18713@sirena.org.uk>
 <20111020162743.GB31337@atomide.com>
 <20111020164006.GA10155@sirena.org.uk>
 <20111020170534.GC31337@atomide.com>
 <20111020172218.GE31337@atomide.com>
 <20111020195734.GB17384@opensource.wolfsonmicro.com>
 <20111020201054.GN3842@atomide.com>
 <20111020214225.GB22709@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020214225.GB22709@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@opensource.wolfsonmicro.com> [111020 14:08]:
> On Thu, Oct 20, 2011 at 01:10:55PM -0700, Tony Lindgren wrote:
> 
> > We still need to figure out how to get the above board specific
> > data to the device driver probe in a way where we can avoid having
> > platform glue code. Any thoughts on that?
> 
> I think we should just not bother with most of the above and see if
> anyone notices, with the exception of always on and status changes it's
> vanishingly rare for anyone to actually do anything constructive with
> them.  

OK

> Neither of the two I mentioned are Linux specific either, they mean
> somehing useful for any OS it's just that the decision is policy which
> is going to depend on the OS version.  Status changes we can probably
> allow people to enable, it'll just mean that older device trees won't
> get good power use out of newer kernels and if you move to an older
> kernel things will start exploding as drivers loose regulator support.
> Always on we can probably live without, it's a combination of
> overspecification and interaction with _has_full_constraints() which
> isn't represented in this binding anyway.

Yeah, lot of these are "how the regulator using driver is using
the regulator" or "how the operating system is using the regulator"
type policies.

Regards,

Tony
