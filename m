Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1KCDtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:49:19 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34401 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1KCDtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:49:16 -0400
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.15.19
Date: Wed, 2 Nov 2011 20:48:54 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH RFC tip/core/rcu 17/28] rcu: Make srcu_read_lock_held()
 call common lockdep-enabled function
Message-ID: <20111103034854.GD2042@leaf>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-17-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320265849-5744-17-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 01:30:38PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> A common debug_lockdep_rcu_enabled() function is used to check whether
> RCU lockdep splats should be reported, but srcu_read_lock() does not
> use it.  This commit therefore brings srcu_read_lock_held() up to date.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Just how signed off does this patch need to be? ;)

- Josh Triplett
