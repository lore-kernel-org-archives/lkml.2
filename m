Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1BXSWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:22:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1BXSWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:22:40 -0500
Date: Thu, 24 Feb 2011 10:22:26 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>,
        Jean Pihet <j-pihet@ti.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [15/70] perf timechart: Adjust perf timechart to the new power
 events
Message-ID: <20110224182226.GB18081@suse.de>
References: <20110222221838.567882669@clark.kroah.org>
 <201102230117.20631.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102230117.20631.trenn@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 01:17:19AM +0100, Thomas Renninger wrote:
> Hi,
> 
> I should have split out this segfault fix.
> 
> On Tuesday 22 February 2011 23:16:54 Greg KH wrote:
> > 2.6.37-stable review patch.  If anyone has any objections, please let
> > us know.
> > 
> > ------------------
> > 
> > From: Thomas Renninger <trenn@suse.de>
> > 
> > commit 20c457b8587bee4644d998331d9e13be82e05b4c upstream.
> > 
> > [This patch is part of mainline git commit 20c457b8587bee4644d9.
> >   This should fix:
> >   http://www.mail-archive.com/linux-perf-
> >   users@vger.kernel.org/msg00057.html
> > 
> >   The regression was introduced by git commit:
> >   4c21adf26f8fcf86a755b9b9f55c2e9fd241e1fb]
> Above link is a nice pointer.
> the rest of the changelog (below) does not fit and describes
> the mainline patch, the tiny fix was part of.
> 
> Don't know whether it's worth to touch it, but if, the changelog (or 
> title) of the patch should be as short as:
> perf: timechart (userspace): Do not segfault on power_end events

I'll leave it as-is as I like to keep the commit messages as close as
possible.

thanks,

greg k-h
