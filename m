Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2AQOKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:10:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab2AQOKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:10:19 -0500
Date: Tue, 17 Jan 2012 15:04:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120117140408.GA10197@redhat.com>
References: <20120110174509.GA30802@redhat.com> <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com> <20120116074540.GE15641@elte.hu> <1326717070.7642.144.camel@gandalf.stny.rr.com> <20120116125329.GB31667@elte.hu> <1326729123.7642.146.camel@gandalf.stny.rr.com> <20120117100222.GH10397@elte.hu> <1326801811.7642.188.camel@gandalf.stny.rr.com> <20120117124023.GA13969@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117124023.GA13969@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Ingo Molnar wrote:
>
> Any tool that requests the signal trace event, and copies the
> full (and now larger) record it got in the ring-buffer, without
> expanding the target record's size accordingly will *BREAK*.
>
> I do not claim that tools will break in practice - i'm raising
> the *possibility* out of caution and i'm frustrated that you
> *STILL* don't understand how ABIs are maintained in Linux.

OK, but what if we rename the tracepoint?

IOW, add the new tracepoint and remove the old one. Of course,
this can confuse the users of the current "signal_generate", but
this is safe. b413d48a does this...

Or this is not allowed too?

Oleg.

