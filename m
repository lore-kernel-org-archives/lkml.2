Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2GaPMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:12:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36523 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2GaPMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:12:47 -0400
Date: Tue, 31 Jul 2012 17:12:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/19] [GIT PULL][v3.6] ftrace: Allow kprobes to work
 with ftace
Message-ID: <20120731151242.GA20169@gmail.com>
References: <20120721021943.274162381@goodmis.org>
 <1343663487.27983.7.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343663487.27983.7.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2012-07-20 at 22:19 -0400, Steven Rostedt wrote:
> > Ingo,
> > 
> > This patch series extends ftrace function tracing utility to be
> > more dynamic for its users. It allows for data passing to the callback
> > functions, as well as reading regs as if a breakpoint were to trigger
> > at function entry.
> > 
> > The main goal of this patch series was to allow kprobes to use ftrace
> > as an optimized probe point when a probe is placed on an ftrace nop.
> > With lots of help from Masami Hiramatsu, and going through lots of
> > iterations, we finally came up with a good solution.
> > 
> > I've tested it vigorously (although, like always, there may be some
> > subtle bug), but I feel it is ready for inclussion for the 3.6 merge
> > window.
> 
> As the merge window opened the day after I sent this (which 
> was also the same day I left for vacation :-p ), I recommend 
> that this goes in v3.7.

Yeah, the timing was a bit unfortunate :-/

> Can you pull this in for 3.7, or do you want me to post 
> another pull request after the merge window closes?

No need to resend, will pull it once the merge window dust has 
settled a bit.

Thanks,

	Ingo
