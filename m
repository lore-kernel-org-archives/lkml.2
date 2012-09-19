Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2ISPjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:39:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33604 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab2ISPjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:39:02 -0400
Date: Wed, 19 Sep 2012 08:34:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH][GIT PULL][v3.7] trace: Don't declare trace_*_rcuidle
 functions in modules
Message-ID: <20120919153446.GA2455@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1347475616.10751.74.camel@gandalf.local.home>
 <20120913152028.GB27521@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913152028.GB27521@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091915-2398-0000-0000-00000B26C99D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175490; UDB=6.00039736; UTC=2012-09-19
 15:38:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:20:28PM +0200, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > Josh made a change to the tracing code that affects both the 
> > work Paul McKenney and I are currently doing. At the last 
> > Kernel Summit back in August, Linus said when such a case 
> > exists, it is best to make a separate branch based off of his 
> > tree and place the change there. This way, the repositories 
> > that need to share the change can both pull them in and the 
> > SHA1 will match for both. Whichever branch is pulled in first 
> > by Linus will also pull in the necessary change for the other 
> > branch as well.
> > 
> > I made a separate branch from Linus's v3.6-rc5 (called 
> > tip/perf/rcu) and applied Josh's change to it. Could you 
> > please pull this into perf/core and whatever branch that Paul 
> > needs it in. Or just have Paul pull this change as well.
> 
> Ok, pulled it into tip:core/rcu and then merged core/rcu into 
> perf/core.

And I have rebased on top of tip:core/rcu and removed the exports
as part of the mondo rebase to address Peter's review feedback.

							Thanx, Paul

