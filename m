Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1JQBeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:34:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44445 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1JQBeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:34:16 -0400
X-Originating-IP: 217.70.178.145
X-Originating-IP: 50.43.15.19
Date: Sun, 16 Oct 2011 18:33:53 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 22/55] rcu: Add grace-period,
 quiescent-state, and call_rcu trace events
Message-ID: <20111017013352.GB19421@leaf>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-22-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-22-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:16AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Add trace events to record grace-period start and end, quiescent states,
> CPUs noticing grace-period start and end, grace-period initialization,
> call_rcu() invocation, tasks blocking in RCU read-side critical sections,
> tasks exiting those same critical sections, force_quiescent_state()
> detection of dyntick-idle and offline CPUs, CPUs entering and leaving
> dyntick-idle mode (except from NMIs), CPUs coming online and going
> offline, and CPUs being kicked for staying in dyntick-idle mode for too
> long (as in many weeks, even on 32-bit systems).
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> rcu: Add the rcu flavor to callback trace events
> 
> The earlier trace events for registering RCU callbacks and for invoking
> them did not include the RCU flavor (rcu_bh, rcu_preempt, or rcu_sched).
> This commit adds the RCU flavor to those trace events.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Did you intend for this commit message to contain two full commit
messages, and three signoffs from you?

Also, the subject doesn't seem to cover the second half of the commit
message.

- Josh Triplett
