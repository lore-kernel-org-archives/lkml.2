Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1KCLOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:14:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57659 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1KCLO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:14:28 -0400
Date: Thu, 3 Nov 2011 12:14:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 17/28] rcu: Make srcu_read_lock_held()
 call common lockdep-enabled function
Message-ID: <20111103111413.GC8198@somewhere.redhat.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103034854.GD2042@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103034854.GD2042@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 08:48:54PM -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:38PM -0700, Paul E. McKenney wrote:
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > A common debug_lockdep_rcu_enabled() function is used to check whether
> > RCU lockdep splats should be reported, but srcu_read_lock() does not
> > use it.  This commit therefore brings srcu_read_lock_held() up to date.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Just how signed off does this patch need to be? ;)

Dunno but I feel uncomfortable now with that strange feeling I'm walking
on the street with two Paul holding my hand on each side.
