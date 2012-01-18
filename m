Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2ARL7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:59:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab2ARL7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:59:52 -0500
Date: Wed, 18 Jan 2012 12:59:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120118115938.GA14863@elte.hu>
References: <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com>
 <20120116074540.GE15641@elte.hu>
 <1326717070.7642.144.camel@gandalf.stny.rr.com>
 <20120116125329.GB31667@elte.hu>
 <1326729123.7642.146.camel@gandalf.stny.rr.com>
 <20120117100222.GH10397@elte.hu>
 <1326801811.7642.188.camel@gandalf.stny.rr.com>
 <20120117124023.GA13969@elte.hu>
 <20120117140408.GA10197@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117140408.GA10197@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/17, Ingo Molnar wrote:
> >
> > Any tool that requests the signal trace event, and copies 
> > the full (and now larger) record it got in the ring-buffer, 
> > without expanding the target record's size accordingly will 
> > *BREAK*.
> >
> > I do not claim that tools will break in practice - i'm 
> > raising the *possibility* out of caution and i'm frustrated 
> > that you *STILL* don't understand how ABIs are maintained in 
> > Linux.
> 
> OK, but what if we rename the tracepoint?
> 
> IOW, add the new tracepoint and remove the old one. Of course, 
> this can confuse the users of the current "signal_generate", 
> but this is safe. b413d48a does this...
> 
> Or this is not allowed too?

Everything is allowed that makes sense and does not break apps, 
with a strong preference towards the simplest possible variant.

I.e. your patch.

Thanks,

	Ingo
