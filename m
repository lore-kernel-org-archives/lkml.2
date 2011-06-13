Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1FMMOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:14:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38799 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1FMMOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:14:49 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=Uk49GNF6wVYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=UkYykcUXkQT7XPaZuSkA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 15/15] tracing/kprobes: Fix kprobe-tracer to support
 stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <20110613115051.GE10960@elte.hu>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172914.290174627@goodmis.org> <20110613102118.GF30962@elte.hu>
	 <1307965484.9218.59.camel@gandalf.stny.rr.com>
	 <20110613115051.GE10960@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 08:14:47 -0400
Message-ID: <1307967287.9218.64.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 13:50 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > > +	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(),
> > > > +			     NULL);
> > > 
> > > pointless linebreak.
> > 
> > Again, probably to do with the 80 char limit.
> 
> Well, the point of the 80 char limit warning these days is to force a 
> cleanup of the code. Breaking the line mindlessly *uglifies* the code 
> so it's pointless to do it.
> 
> In terms of terminal readability line length up to 90-100 cols is 
> acceptable for code that is otherwise not ugly.

I totally agree. I've just had arguments with others that are more 80
character nazi than I am. ;)

-- Steve


