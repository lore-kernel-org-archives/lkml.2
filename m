Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2IMPUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:20:36 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34136 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2IMPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:20:35 -0400
Date: Thu, 13 Sep 2012 17:20:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH][GIT PULL][v3.7] trace: Don't declare trace_*_rcuidle
 functions in modules
Message-ID: <20120913152028.GB27521@gmail.com>
References: <1347475616.10751.74.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347475616.10751.74.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Josh made a change to the tracing code that affects both the 
> work Paul McKenney and I are currently doing. At the last 
> Kernel Summit back in August, Linus said when such a case 
> exists, it is best to make a separate branch based off of his 
> tree and place the change there. This way, the repositories 
> that need to share the change can both pull them in and the 
> SHA1 will match for both. Whichever branch is pulled in first 
> by Linus will also pull in the necessary change for the other 
> branch as well.
> 
> I made a separate branch from Linus's v3.6-rc5 (called 
> tip/perf/rcu) and applied Josh's change to it. Could you 
> please pull this into perf/core and whatever branch that Paul 
> needs it in. Or just have Paul pull this change as well.

Ok, pulled it into tip:core/rcu and then merged core/rcu into 
perf/core.

Thanks,

	Ingo
