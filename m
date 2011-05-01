Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab1EAPwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:52:42 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47494 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1EAPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:52:41 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 1 May 2011 08:52:25 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 11/86] rcu: Add boosting to TREE_PREEMPT_RCU
 tracing
Message-ID: <20110501155225.GF14829@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304256126-26015-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:20:51AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Includes total number of tasks boosted, number boosted on behalf of each
> of normal and expedited grace periods, and statistics on attempts to
> initiate boosting that failed for various reasons.

In this patch series, you have several cases where you improve the trace
output in one patch, and then update the documentation in a subsequent
patch.  You might consider doing both in the same patch, so that at each
step the documentation matches the kernel.

- Josh Triplett
