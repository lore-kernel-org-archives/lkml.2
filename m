Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934890Ab0KQRVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:21:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab0KQRVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:21:12 -0500
Date: Wed, 17 Nov 2010 18:21:11 +0100
From: Marcus Meissner <meissner@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/time: Make /proc/timer_list mode 0400
Message-ID: <20101117172111.GX20727@suse.de>
References: <20101117170822.GW20727@suse.de> <1290014312.2109.1065.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290014312.2109.1065.camel@laptop>
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 06:18:32PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-17 at 18:08 +0100, Marcus Meissner wrote:
> > Hi,
> > 
> > /proc/timer_list contains kernel addresses, like e.g.:
> >  #0: <c000000001404158>, tick_sched_timer, S:01, .tick_nohz_restart_sched_tick, swapper/0
> >  ...
> > 
> > Avoid leaking them to user space to make writing kernel exploits a bit harder.
> > 
> > (I currently cannot think of a userland tool that uses this, this is
> > likely pretty much root-only.)
> 
> iirc powertop parses this..

powertop already says on startup:

	PowerTOP needs to be run as root to collect enough information

And as developer tool it usually is for people having root access.

Ciao, Marcus
