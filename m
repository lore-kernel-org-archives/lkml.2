Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1JQB4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:56:03 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51563 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1JQB4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:56:01 -0400
X-Originating-IP: 217.70.178.145
X-Originating-IP: 50.43.15.19
Date: Sun, 16 Oct 2011 18:55:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH tip/core/rcu 44/55] rcu: wire up RCU_BOOST_PRIO for
 rcutree
Message-ID: <20111017015542.GH19421@leaf>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-44-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315332049-2604-44-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 11:00:38AM -0700, Paul E. McKenney wrote:
> RCU boost threads start life at RCU_BOOST_PRIO, while others remain
> at RCU_KTHREAD_PRIO.  While here, change thread names to match other
> kthreads, and adjust rcu_yield() to not override the priority set by
> the user.  This last change sets the stage for runtime changes to
> priority in the -rt tree.

This seems like either two or three independent changes, which should go
in separate commits.  You could plausibly group the rcu_yield changes
together with the rest, but the thread naming seems like a separate
commit.

- Josh Triplett
