Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0LHIHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:07:54 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:38527 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0LHIHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:07:52 -0500
Date: Wed, 8 Dec 2010 09:07:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] [patch 2/3] nohz: fix printk_needs_cpu() return value
 on offline cpus
Message-ID: <20101208080749.GB2523@osiris.boeblingen.de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
 <20101126120235.406766476@de.ibm.com>
 <1290773512.2145.139.camel@laptop>
 <20101207213241.GL14849@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207213241.GL14849@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 01:32:41PM -0800, Greg KH wrote:
> On Fri, Nov 26, 2010 at 01:11:52PM +0100, Peter Zijlstra wrote:
> > On Fri, 2010-11-26 at 13:00 +0100, Heiko Carstens wrote:
> > > plain text document attachment (002_printk_needs_cpu.diff)
> > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > 
> > > This patch fixes a hang observed with 2.6.32 kernels where timers got
> > > enqueued on offline cpus.
[...]
> 
> Is this going to make it into .37, or is it going to wait until .38?

I hope it will go into .37. The same should be true for the
get_next_timer_interrupt() which addresses the same problem.
Peter, Ingo?
