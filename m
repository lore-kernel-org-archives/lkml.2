Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1FDKYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 06:24:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1FDKYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 06:24:05 -0400
Date: Sat, 4 Jun 2011 12:23:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com
Subject: Re: [patch] perf - comment /proc/sys/kernel/perf_event_paranoid to
 be part of user ABI
Message-ID: <20110604102350.GC16292@elte.hu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu>
 <1306246306.18455.36.camel@twins>
 <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu>
 <20110524194810.GB27634@elte.hu>
 <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
 <4DDC1BB2.4090503@gmail.com>
 <20110524212925.GL27634@elte.hu>
 <alpine.DEB.2.00.1106031751170.29381@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106031751170.29381@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Tue, 24 May 2011, Ingo Molnar wrote:
> 
> > I agree with Vince that as far as shell scripts are concerned, checking 
> > /proc/sys/kernel/perf_event_paranoid would work best - and it works better than 
> > having to check the perf syscall.
> > 
> > Vince: mind sending a patch that adds a comment to perf_event_paranoid that 
> > userspace relies on the existence of that file as a feature check? Having such 
> > reminders in the code works even better than frequent testing ;-)
> 
> Such a patch is included below.  Not sure if this is exactly what you 
> meant.

Yeah, that's exactly what i meant - we don't need more really.

Most sysctls are not ABIs (there's no userspace that relies on them) 
so the general attitude is to change them freely and backtrack if 
something breaks unexpectedly. We can avoid that by commenting the 
dependency.

Thanks,

	Ingo
