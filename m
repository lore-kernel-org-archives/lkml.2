Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286Ab2ERGdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:33:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61293 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2ERGdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:33:14 -0400
Date: Fri, 18 May 2012 08:33:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: Fix broken strings in RCU's
 source code.
Message-ID: <20120518063308.GA429@gmail.com>
References: <20120517221217.GA12196@linux.vnet.ibm.com>
 <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337292765-12221-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <1337293209.4281.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337293209.4281.111.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2012-05-17 at 15:12 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Although the C language allows you to break strings across lines, doing
> > this makes it hard for people to find the Linux kernel code corresponding
> > to a given console message.  This commit therefore fixes broken strings
> > throughout RCU's source code. 
> 
> While I'm not a strict 80 chars zealot, I do find exceedingly 
> long lines utterly annoying, editors either wrap them in the 
> most hideous way or you don't see them.

Well, but if it's exceedingly long in the editor then it's 
probably exceedingly long in the syslog as well and need fixing, 
right?
 
Or it's printed inside some exceedingly deep nested block of 
code, which too could use improvement, right?

Thanks,

	Ingo
