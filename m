Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1KOVux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:50:53 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49033 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab1KOVuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:50:52 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.15.19
Date: Tue, 15 Nov 2011 13:50:41 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/9] Preview of additional RCU changes for
 3.3
Message-ID: <20111115215041.GF31473@leaf>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:27:36PM -0800, Paul E. McKenney wrote:
> This patchset is in addition to the set previously posted (see
> https://lkml.org/lkml/2011/11/2/363).  This new set permits the
> reworked RCU_FAST_NO_HZ code to be used from TREE_PREEMPT_RCU,
> allows rcutorture to shut down the system after a fixed time
> period (useful for KVM-based testing), adds an API to
> replace the "->pid == 0" discussed in response to the earlier
> patch set, and applies this API where applicable.  The patches are
> as follows:
> 
> 1.	Update the RCU_FAST_NO_HZ config definition to allow it to
> 	be used in TREE_PREEMPT_RCU builds, since that is now legal.
> 2.	Add a module parameter that permit rcutorture to shut down the
> 	system cleanly after the test has run for the specified time.
> 3.	Add a module parameter to allow rcutorture start running
> 	as soon as it is initialized.
> 4.	Add is_idle_task() API to replace open-coded tests of ->pid
> 	against zero.
> 5-9.	Apply the new is_idle_task() API where it makes sense.

I replied to patches 2-4 with review comments.  For the rest:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
