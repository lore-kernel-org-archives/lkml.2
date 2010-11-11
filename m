Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab0KKBeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 20:34:21 -0500
Received: from www.tglx.de ([62.245.132.106]:56396 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab0KKBeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 20:34:20 -0500
Date: Thu, 11 Nov 2010 02:33:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Sharp <dhsharp@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFD tracing] Tracing ABI Work Plan
In-Reply-To: <20101111004612.GB32564@Krystal>
Message-ID: <alpine.LFD.2.00.1011110158390.2900@localhost6.localdomain6>
References: <20101111004612.GB32564@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

On Wed, 10 Nov 2010, Mathieu Desnoyers wrote:

> Following the Kernel Summit 2010 and Linux Plumber Conference, we came up to
> the following conclusions (we're finally making progress !!):
>
> - The ABIs of Ftrace and Perf are in active use, thus Linus has stated
>   that they can not be changed.
> - It has been stated at Kernel Summit that new ABIs should not go into
>   mainline first, but should be tested in an out-of-tree first, and get
>   feed back from their users.
> - The goal is to have both Perf and Ftrace work well together, and have
>   a more generic ABI. But the current ABI of both Perf and Ftrace fail to
>   meet each others requirements, as well as requirement from a large user-base.
> 
> Therefore, as Thomas Gleixner pointed out, we have two choices: either we stop
> there, keep the current ABIs and give up, or we create a new set of ABIs. I
> hereby propose to come up with a new set of tracing ABIs and, this time, that we
> _take our time_ before mainlining them -- trying them out in a separate tree for
> a while beforehand. There is no hurry to push anything to mainline anyway,
> because Ftrace and Perf answer the most pressing kernel developer tracing needs.
> Let's work on the new ABI at the pace that everyone is happy with it.

Using the observed progress rate so far that means pace is infinite
slow.

> First of all, I'm not a big fan of "hide-and-seek" games regarding motives and
> end-goals, especially when it comes to designing ABIs. So here is my entire
> high-level roadmap towards having tracer fully usable by my user-base in the

Roadmap? You failed to provide the corresponding spreadsheets, project
plans and milestones along with that.

> mainline kernel. I propose to split the upcoming task in the following 4
> sub-items.
> 
> 
> A) New ABI for user-space
> 
> This new ABI will provide the features long-awaited by tracing users. We've
> already started this discussion by listing the requirements and acknowledging
> them. It is now time to start discussing the ABI. Upon disagreement on answering
> a specific requirement, two questions will arise:
> 
> 1. How much trouble it really is to take care of this requirement. If the answer
>    is "not much", then we simply take care of it.
> 2. If it really is a big deal to take care of a requirement at the ABI level,
>    then we will have to discuss the use-cases.

Sorry for being sarcastic, but that reads like it was adopted from the
worst possible management course handout. You forgot to mention that
the process should involve rating matrixes and other state of the art
evaluation methods.

> Once we are on the same page with respect to these requirements, we can come up
> with an ABI proposal for:
> 
> - Tracing control
> - Trace format

That's going to happen somewhere around 2050, right? That's good as I
won't be in your way then anymore.

<Snipping the other proposals as I need some sleep>

I just want to tell you once more, that these marvelous writeups and
proposals which we have seen repeatedly in the last years do not solve
anything. Quite the contrary, they make folks loose interest, cause
grumpiness and prevent any useful outcome.

The time wasted on all these managerial proposals and work plans which
we have seen come by in the last years plus the resulting fruitless
discussions would have been sufficient to write at least two
generations of useful tracers.

The requirement list has been beaten to death several times already
along with the various options of trace formats, so we really are at
the point where you folks need to sit down and come up with real code
which can be discussed and improved on a technical base.

Either that or you immediately install the "Work Plan Committee" which
will make sure that there will be no progress ever.

Thanks,

	tglx
