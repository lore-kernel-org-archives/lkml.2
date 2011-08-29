Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1H2P4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:56:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:53299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1H2P4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:56:00 -0400
Subject: Re: [PATCH 16/32] nohz/cpuset: Wake up adaptive nohz CPU when a
 timer gets enqueued
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 17:55:37 +0200
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-17-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314633337.2816.104.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 17:51 +0200, Peter Zijlstra wrote:
> 
> Also, all the delta_jiffies stuff in the current
> tick_nohz_stop_sched_tick() deals with this, why duplicate the logic?
> 
Damn, n/m this is about new timers.. tick_nohz_new_timer() then.
