Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab2GAGyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 02:54:17 -0400
Received: from ozlabs.org ([203.10.76.45]:38967 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab2GAGyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 02:54:13 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 01/22] rcu: Control RCU_FANOUT_LEAF from boot-time parameter
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com> <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 01 Jul 2012 15:49:42 +0930
Message-ID: <87y5n4xatd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 08:17:00 -0700, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Although making RCU_FANOUT_LEAF a kernel configuration parameter rather
> than a fixed constant makes it easier for people to decrease cache-miss
> overhead for large systems, it is of little help for people who must
> run a single pre-built kernel binary.
> 
> This commit therefore allows the value of RCU_FANOUT_LEAF to be
> increased (but not decreased!) via a boot-time parameter named
> rcutree.rcu_fanout_leaf.
...
> +static int rcu_fanout_leaf = CONFIG_RCU_FANOUT_LEAF;
> +module_param(rcu_fanout_leaf, int, 0);

Maybe it's overkill, but 0400 or 0444 might be a nice touch.

Cheers,
Rusty.
