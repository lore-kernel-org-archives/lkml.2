Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2AZKKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:10:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab2AZKKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:10:50 -0500
Date: Thu, 26 Jan 2012 11:10:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120126101028.GB3853@elte.hu>
References: <20120110174509.GA30802@redhat.com>
 <20120113182015.GA3902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113182015.GA3902@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Hello,
> 
> Please pull from
> 
> 	git://github.com/utrace/linux sigtrace
...
> Oleg Nesterov (2):
>       tracing: let trace_signal_generate() report more info, kill overflow_fail/lose_info
>       tracing: send_sigqueue() needs trace_signal_generate() too
> 
>  include/trace/events/signal.h |   85 +++++++++++------------------------------
>  kernel/signal.c               |   28 +++++++++----
>  2 files changed, 41 insertions(+), 72 deletions(-)

Pulled into perf/core, thanks Oleg!

(Btw., you might want to set up a tree on korg, it's generally 
more trusted than github.com.)

Thanks,

	Ingo
