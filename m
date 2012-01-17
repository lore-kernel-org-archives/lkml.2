Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2AQPCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:02:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab2AQPCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:02:01 -0500
Date: Tue, 17 Jan 2012 15:55:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120117145540.GA12626@redhat.com>
References: <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com> <20120116074540.GE15641@elte.hu> <1326717070.7642.144.camel@gandalf.stny.rr.com> <20120116125329.GB31667@elte.hu> <1326729123.7642.146.camel@gandalf.stny.rr.com> <20120117100222.GH10397@elte.hu> <1326801811.7642.188.camel@gandalf.stny.rr.com> <20120117124023.GA13969@elte.hu> <1326811069.17534.46.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326811069.17534.46.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Steven Rostedt wrote:
>
> People are adding tracepoints all over the kernel without much thought.

Including the tracepoints in __send_signal(). They are stupid and limited.

Yes, I should blame myself in the first place. I was cc'ed, I participated
in the discussion when they were added.

> We take much more care when we add a system call. By making tracepoints
> have as strict a ABI as system calls will cause a maintenance nightmare
> in the future. I guarantee that!

Personally I agree.

That said, I am going to send the patch which adds the new tracepoint
unless Ingo changes his mind. The new info was requested by users who
actually use these events.

Oleg.

