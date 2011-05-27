Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1E0Tbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:31:51 -0400
Received: from relais.videotron.ca ([24.201.245.36]:19335 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1E0Tbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:31:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 27 May 2011 15:31:47 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Move Qualcomm gpio drivers into drivers dir
In-reply-to: <8ya8vts6qzn.fsf@huya.qualcomm.com>
Message-id: <alpine.LFD.2.00.1105271531200.3207@xanadu.home>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <20110527031319.GH5032@ponder.secretlab.ca>
 <8yad3j46r97.fsf@huya.qualcomm.com> <8ya8vts6qzn.fsf@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, David Brown wrote:

> On Fri, May 27 2011, David Brown wrote:
> 
> > On Thu, May 26 2011, Grant Likely wrote:
> >
> >> On Wed, May 18, 2011 at 02:50:46PM -0700, David Brown wrote:
> >>> This patch series moves the Qualcomm MSM gpio device drivers into the
> >>> drivers/gpio directory.
> >>> 
> >>> The MSM's have two flavors of gpio driver.  The one for the newer
> >>> v7-based chips is a bit cleaner, and can just be moved.  The one for
> >>> the older v6-based chips took some cleanup to get rid of numerous
> >>> ifdefs based on the particular machine.  Both drivers can now be
> >>> selected and will be used on appropriate targets.
> >>> 
> >>> There is still a minor entanglement with the MSM-specific gpiomux
> >>> code.  This will be cleaned up as MSM moves to use pinmux.
> >>> 
> >>> David Brown (7):
> >>>   msm: gpio: Remove unsupported devices
> >>>   msm: Remove chip-ifdefs for GPIO io mappings
> >>>   msm: gpio: Remove chip-specific register definitions
> >>>   msm: gpio: Remove ifdefs on gpio chip registers
> >>>   msm: gpiomux: Move public API to public header
> >>>   gpio_msm: Move Qualcomm v6 MSM driver into drivers
> >>>   gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers
> >>
> >> What's the status of this series.  I only got cc'd on the last two
> >> patches; did you want me to pick up the whole lot, or is it being
> >> merged via the msm tree?
> >
> > Let me send out an update, incorporating the suggestions.  I need to
> > rebase these changes off of the current MSM code, since the msm-next
> > tree contains changes that aren't going into the merge window because of
> > extra ARM scrutiny.
> >
> >> Alternately, if there is a git branch with these patches in it, then I
> >> can merge that instead of applying individually.
> >
> > I'll send you a pull request after I send out the updates.
> 
> Oh, and in case it isn't clear, I wasn't expecting these to make it into
> this merge window.

Why not?


Nicolas
