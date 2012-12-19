Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2LSQ2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:28:23 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:58475 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810Ab2LSQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:28:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18l5IZNxWJH+kfCA5pLD1zL
Date: Wed, 19 Dec 2012 08:28:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Felipe Balbi <balbi@ti.com>, Luciano Coelho <coelho@ti.com>,
        svenkatr@ti.com, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219162811.GL4989@atomide.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
 <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <50D19040.5090404@ti.com>
 <20121219100909.GO4985@opensource.wolfsonmicro.com>
 <50D19463.5010605@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D19463.5010605@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [121219 02:20]:
> On 12/19/2012 11:09 AM, Mark Brown wrote:
> > On Wed, Dec 19, 2012 at 11:00:32AM +0100, Peter Ujfalusi wrote:
> > 
> >> I don't know the state of the common clock framework for OMAPs. Is it already
> >> up in 3.7? Or going for 3.8? 3.9? 3.10?...
> >> We need CCF to resolve this. I can cook up the clock driver for the 32k clock
> >> from twl, but in order to use it we need CCF on OMAP.
> > 
> > Well, we at least ought to make sure it doesn't appear in the regulator
> > DT bindings even if it's handled via some OMAP magic - that was the key
> > point here.
> 
> Sure. It must be a clock driver. I already have similar driver (for McPDM fclk
> clock) for twl6040.
> Let me check linux-next, if CCF is there for OMAP I can send the 32k clock
> driver soon (after writing it and testing it). It is going to be for 3.9 but
> we can roll it with us I think locally to resolv issues.

The omap common clock patches are now in mainline kernel as of v3.8
merge window.

Tony
