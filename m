Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1JMRnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:43:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39704 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1JMRm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:42:58 -0400
Date: Thu, 13 Oct 2011 11:42:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Kevin Hilman <khilman@ti.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, tony@atomide.com,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH 3.1-rc3] gpio/omap: fix build error with certain OMAP1
 configs
Message-ID: <20111013174255.GH18574@ponder.secretlab.ca>
References: <201108231342.25101.jkrzyszt@tis.icnet.pl>
 <87sjoshx2k.fsf@ti.com>
 <201110071430.14420.jkrzyszt@tis.icnet.pl>
 <alpine.DEB.2.00.1110102356530.7624@dell>
 <87fwiz8okk.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fwiz8okk.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 09:45:15AM -0700, Kevin Hilman wrote:
> Aaro Koskinen <aaro.koskinen@iki.fi> writes:
> 
> > Hi,
> >
> > On Fri, 7 Oct 2011, Janusz Krzysztofik wrote:
> >> Dnia wtorek, 23 sierpnia 2011 o 19:11:47 Kevin Hilman napisał(a):
> >>> Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> writes:
> >>>> With commit f64ad1a0e21a, "gpio/omap: cleanup _set_gpio_wakeup(), remove
> >>>> ifdefs", access to build time conditionally omitted 'suspend_wakeup'
> >>>> member of the 'gpio_bank' structure has been placed unconditionally in
> >>>> function _set_gpio_wakeup(), which is always built. This resulted in the
> >>>> driver compilation broken for certain OMAP1, i.e., non-OMAP16xx,
> >>>> configurations.
> >>>>
> >>>> Really required or not in previously excluded cases, define this
> >>>> structure member unconditionally as a fix.
> >>>>
> >>>> Tested with a custom OMAP1510 only configuration.
> >>>>
> >>>> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> >>>
> >>> Verified that this fixes a build problem when building for OMAP1
> >>> (730/850 only)
> >>>
> >>> Acked-by: Kevin Hilman <khilman@ti.com>
> >
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> >
> >>> Grant, can you queue this as a fix for 3.1-rc?
> >>
> >> Sorry for being so late with checking this, but it looks like this patch
> >> never got into 3.1-rc, as it should, leaving the issue not fixed.
> >> Any chance for it still being pushed into 3.1?
> >
> > This patch is one-liner, and still needed to get 3.1-rc9 compiled and
> > running on e.g. Amstrad E3, so I think it should get into 3.1.
> 
> Grant?

I'll pick this up now and send it on to Linus

g.

> 
