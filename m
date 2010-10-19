Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab0JSLqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:46:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39226 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484Ab0JSLqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:46:12 -0400
Date: Tue, 19 Oct 2010 13:45:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Pierre Tardy <tardyp@gmail.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        linux-trace-users@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        rjw@sisk.pl, linux-omap@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Steven Rostedt <rostedt@goodmis.org>, Frank Eigler <fche@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH [0/4] perf: clean-up of power events API
Message-ID: <20101019114501.GA25371@elte.hu>
References: <201010062334.46971.trenn@suse.de>
 <4CB095FA.8060803@linux.intel.com>
 <20101010121928.GA2688@elte.hu>
 <201010191331.03080.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010191331.03080.trenn@suse.de>
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


* Thomas Renninger <trenn@suse.de> wrote:

> > Most definitely. It's no accident that it took such a long time for this issue 
> > to be raised in the first place. It's a rare occurance -
>
> Do you agree that this occurance happened now and these events should get cleaned 
> up before ARM and other archs make use of the broken interface?
>
> If not, discussing this further, is a big waste of time... and Jean would have to 
> try to adapt his ARM code on the broken ABI...

The discussion seems to have died down somewhat. Please re-send to lkml the latest 
patches you have to remind everyone of the latest state of things - the merge window 
is getting near.

My only compatibility/ABI point is basically that it shouldnt break _existing_ 
tracepoints (and users thereof). If your latest bits meet that then it ought to be a 
good first step. You are free to (and encouraged to) introduce more complete sets of 
events.

Thanks,

	Ingo
