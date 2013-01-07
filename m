Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3AGPvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:51:42 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49256 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab3AGPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:51:41 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.39.152
Date: Mon, 7 Jan 2013 07:51:33 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] RCU fixes for 3.9
Message-ID: <20130107155132.GB11145@leaf>
References: <20130105170920.GA13766@linux.vnet.ibm.com>
 <20130105171916.GA13383@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130105171916.GA13383@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 09:19:16AM -0800, Paul E. McKenney wrote:
> On Sat, Jan 05, 2013 at 09:09:20AM -0800, Paul E. McKenney wrote:
> > Hello!
> > 
> > The following fixes are intended for 3.9:
> > 
> > 1.	Fix int/long type confusion in trace_rcu_start_batch().
> > 2.	Declare rcu_is_cpu_rrupt_from_idle() static, courtesy of
> > 	Josh Triplett.
> > 3.	Make rcu_eqs_enter_common() trace the new nesting value instead
> > 	of zero, courtesy of Li Zhong.
> > 4.	Silence a gcc array-out-of-bounds false positive in rcu_init_one().
> > 5.	Code style fix in rcu_torture_barrier_init(), courtesy of Sasha Levin.
> 
> and:
> 
> 6.	Grammar fix to rcu_scheduler_active comment, courtesy of Cody
> 	Schafer.

One comment on patch 4/6, but in any case,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
for the whole series.
