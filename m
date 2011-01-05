Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1AEUS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:18:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1AEUS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:18:26 -0500
Date: Wed, 5 Jan 2011 21:18:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Daney <ddaney@caviumnetworks.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        peterz@infradead.org, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
Message-ID: <20110105201801.GA10603@elte.hu>
References: <cover.1294239591.git.jbaron@redhat.com>
 <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com>
 <4D24AB1B.2010209@caviumnetworks.com>
 <1294249439.26623.35.camel@gandalf.stny.rr.com>
 <4D24BED1.5000900@zytor.com>
 <20110105191424.GA7820@elte.hu>
 <4D24C756.9070302@caviumnetworks.com>
 <20110105195043.GA9399@elte.hu>
 <4D24CF95.5090006@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D24CF95.5090006@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Daney <ddaney@caviumnetworks.com> wrote:

> On 01/05/2011 11:50 AM, Ingo Molnar wrote:
> >
> >* David Daney<ddaney@caviumnetworks.com>  wrote:
> >
> >>On 01/05/2011 11:14 AM, Ingo Molnar wrote:
> >>>
> >>>* H. Peter Anvin<hpa@zytor.com>   wrote:
> >>>
> >>>>On 01/05/2011 09:43 AM, Steven Rostedt wrote:
> >>>>>On Wed, 2011-01-05 at 09:32 -0800, David Daney wrote:
> >>>>>
> >>>>>>This patch will conflict with the MIPS jump label support that Ralf has
> >>>>>>queued up for 2.6.38.
> >>>>>
> >>>>>Can you disable that support for now? As Linus said at Kernel Summit,
> >>>>>other archs jumped too quickly onto the jump label band wagon. This
> >>>>>change really needs to get in, and IMO, it is more critical to clean up
> >>>>>the jump label code than to have other archs implementing it.
> >>>>>
> >>>>
> >>>>Ralf is really good... perhaps we can get the conflicts resolved?
> >>>
> >>>Yep, the best Git-ish way to handle that is to resolve the conflicts whenever they
> >>>happen - i.e. whoever merges his tree upstream later. No need for anyone to 'wait'
> >>>or undo anything.
> >>>
> >>
> >>There will be no git conflicts, as the affected files are disjoint.
> >
> >I regularly resolve semantic conflicts in merge commits - or in the first followup
> >commit.
> >
> 
> But I am guessing that neither you, nor Linus, regularly build MIPS
> kernels with GCC-4.5.x *and* jump label support enabled.  [...]

I build MIPS defconfig kernels at least once per day - so at least serious, 
wide-ranging issues should not slip through. Rarer combos possibly - but that's true 
of pretty much anything.

> [...] So how would such semantic conflict ever be detected?  I would expect the 
> conflict to first occur when Linus pulls Ralf's tree.

If that slips through then a fix is queued up?

Thanks,

	Ingo
