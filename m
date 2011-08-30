Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1H3PG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:06:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42453 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab1H3PG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:06:56 -0400
Date: Tue, 30 Aug 2011 17:06:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 16/32] nohz/cpuset: Wake up adaptive nohz CPU when a
 timer gets enqueued
Message-ID: <20110830150648.GT9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-17-git-send-email-fweisbec@gmail.com>
 <1314633337.2816.104.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314633337.2816.104.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 05:55:37PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 17:51 +0200, Peter Zijlstra wrote:
> > 
> > Also, all the delta_jiffies stuff in the current
> > tick_nohz_stop_sched_tick() deals with this, why duplicate the logic?
> > 
> Damn, n/m this is about new timers.. tick_nohz_new_timer() then.

I can call that tick_nohz_new_timer() if you prefer yeah. I personally
don't mind either name.
