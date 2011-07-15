Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1GOWEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 18:04:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55012 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab1GOWEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:04:52 -0400
Date: Fri, 15 Jul 2011 15:04:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110715220447.GJ2327@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <1310746315.2586.370.camel@twins>
 <20110715165613.GC2327@linux.vnet.ibm.com>
 <201107151748.07109.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107151748.07109.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 05:48:06PM -0400, Ed Tomlinson wrote:
> On Friday 15 July 2011 12:56:13 Paul E. McKenney wrote:

[ . . . ]

> > OK.  Ed, would you be willing to try the patch out?
> 
> I am booted at the same git commit with a bluetooth and the disable local_bh around softirq()
> patch from this thread.  So far so good.  Not sure how 'easy' this one is to trigger a second time -
> I've been running with threadirq enabled since .39 came out.  Last night was the first deadlock...
> If nothing happened post rc6 to make it more likely it could be a while before it triggers again.

Thank you for trying it out, Ed!  And I know that you will not be shy
should the problem recur.  ;-)

							Thanx, Paul
