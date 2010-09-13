Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0IMEf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 00:35:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49595 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750712Ab0IMEfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 00:35:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19s3ywapnVsV6/0ja0Z05rSHyrkXViOvpiogYCCsA
	/n3cvmPgWiexHq
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284282392.2251.81.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
	 <1284237380.2251.56.camel@laptop>
	 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
	 <1284282392.2251.81.camel@laptop>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 06:35:47 +0200
Message-Id: <1284352547.7321.51.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 11:06 +0200, Peter Zijlstra wrote:
> On Sat, 2010-09-11 at 13:48 -0700, Linus Torvalds wrote:

> > And I don't like how you dismissed the measured latency improvement.
> > And yes, I do think latency matters. A _lot_.
> 
> OK, we'll make it better and sacrifice some throughput, can do, no
> problem.

I'm not seeing high wakeup latencies, even under hefty load.  Mathieu's
testcase is bad, but apparently solely due to START_DEBIT placement.
That's kind of a sticky wicket.  I've shot it in the heart before, but
regretted doing so when I looked at kbuild vs static load fairness.

	-Mike

