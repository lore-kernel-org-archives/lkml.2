Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1BPOxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1BPOxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:53:11 -0500
Date: Wed, 16 Feb 2011 12:52:04 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
	filtering
Message-ID: <20110216145204.GB7357@ghostprotocols.net>
References: <20110208015617.902200587@goodmis.org> <20110215044425.GA9994@elte.hu> <1297776787.23343.104.camel@gandalf.stny.rr.com> <1297787362.23343.109.camel@gandalf.stny.rr.com> <20110215165302.GA2272@nowhere> <20110215183558.GE30208@ghostprotocols.net> <4D5BD24F.3060601@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5BD24F.3060601@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 16, 2011 at 10:34:07PM +0900, Masami Hiramatsu escreveu:
> (2011/02/16 3:35), Arnaldo Carvalho de Melo wrote:

> > Yeah, usability of the --filter parameter in perf is a bit
> > (understatement) lacking, one has to look at the /format thing in
> > /sys/kernel/debug/tracing... and not commit any mistake, else a generic
> > invalid 22 message is spit out.

> And also, there seems very less comment in perf-record.txt.

> --filter=<filter>::
>         Event filter.

> Hmm, I think, at least, there should be a comment where user should
> refer to and if possible, how he can use it...

> > I tried it and after some back and forth changing hats and scratching my
> > head while doing so, it got to work.

> > I talked with Steven and the same operation using trace-cmd would
> > produce a better error report, stating that the field used in the filter
> > expression was not valid.

> If possible, please show us what parameters we can use on that event too.
> perf list gives us a list of events, but not show us what parameters
> we can use on those events. I think we can update perf list for that
> purpose.

> e.g.)
> perf list --field kvm:kvm_entry
>  unsigned short common_type;
>  unsigned char common_flags;
>  unsigned char common_preempt_count;
>  int common_pid;
>  int common_lock_depth;
>  unsigned int vcpu_id;

That is a cool idea, I would accept a patch implementing this :-)

- Arnaldo
