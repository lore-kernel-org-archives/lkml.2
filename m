Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab0LCAoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:44:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40393 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0LCAod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:44:33 -0500
Date: Thu, 2 Dec 2010 22:44:06 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/4] perf/core improvements
Message-ID: <20101203004406.GA18492@ghostprotocols.net>
References: <1291318772-30880-1-git-send-email-acme@infradead.org>
 <alpine.LFD.2.00.1012022358380.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012022358380.2653@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 03, 2010 at 12:00:09AM +0100, Thomas Gleixner escreveu:
> On Thu, 2 Dec 2010, Arnaldo Carvalho de Melo wrote:
> 
> > Hi Ingo,
> > 
> >         Please consider pulling after at least Ian and Peter acks it:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> > 
> > 	Peter already acked a previous version of this, so I left his acked by
> > there, this new one is much simpler than the first one he acked, so I think
> > he'll be happy with this one as well, Peter?
> > 
> > 	I tested it using the perf tools built from what is in tip/perf/urgent
> > and it works as expected, i.e. the new fields are just discarded since they are
> > stashed as a trailer in the MMAP, FORK, etc events, so old tools process new
> > perf.data files just fine.
> > 
> > 	Also the new tools works on older kernels, also tested.
> > 
> > 	Ian, if you prefer, please test it before Ingo merges it.
> 
> Did so. Have some odd fallout:
> 
>     tracepoint event: type 65535
> 
>     data->tid 2621441 data->pid 9
> 
> Investigating. Please wait

Thanks, as I said on IRC, perhaps I neglected the non-perf bits of perf
:-\

- Arnaldo

Guess even for people understanding that "perf" is not just about
profiling that name gets in the way, "observe" is the only thing I think
I would think in a potential rename, but heck, it has 3+ letters :-\
