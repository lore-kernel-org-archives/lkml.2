Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966036Ab2ERMdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:33:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51254 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab2ERMdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:33:38 -0400
Date: Fri, 18 May 2012 05:33:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
Message-ID: <20120518123303.GK2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120517221217.GA12196@linux.vnet.ibm.com>
 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337293209.4281.111.camel@twins>
 <20120518063308.GA429@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518063308.GA429@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051812-5112-0000-0000-0000081F9989
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 08:33:08AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2012-05-17 at 15:12 -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Although the C language allows you to break strings across lines, doing
> > > this makes it hard for people to find the Linux kernel code corresponding
> > > to a given console message.  This commit therefore fixes broken strings
> > > throughout RCU's source code. 
> > 
> > While I'm not a strict 80 chars zealot, I do find exceedingly 
> > long lines utterly annoying, editors either wrap them in the 
> > most hideous way or you don't see them.
> 
> Well, but if it's exceedingly long in the editor then it's 
> probably exceedingly long in the syslog as well and need fixing, 
> right?
> 
> Or it's printed inside some exceedingly deep nested block of 
> code, which too could use improvement, right?

The longest source-code line produced by this patch is 104 characters.

I am hoping that this is not considered excessively long!

							Thanx, Paul

