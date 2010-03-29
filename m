Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0C2ODK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:03:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60780 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751727Ab0C2ODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:03:08 -0400
Date: Mon, 29 Mar 2010 10:03:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: Re: [RFC patch] extable and module add object is static
Message-ID: <20100329140304.GA24478@Krystal>
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal> <20100327232024.GB4685@Krystal> <20100327234314.GL2343@linux.vnet.ibm.com> <20100328000234.GA4924@Krystal> <4BB004ED.5060106@cn.fujitsu.com> <1269852814.12097.167.camel@laptop> <20100329131633.GA22730@Krystal> <4BB0B13F.9080800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB0B13F.9080800@kernel.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:00:22 up 65 days, 16:37,  7 users,  load average: 0.06, 0.05,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo (tj@kernel.org) wrote:
> Hello,
> 
> On 03/29/2010 10:16 PM, Mathieu Desnoyers wrote:
> > That's great! Tejun, can you point me out to an update version of these
> > patches ? I am particularly interested in being able to know the range of
> > statically defined per-cpu data.
> 
>   http://thread.gmane.org/gmane.linux.kernel/958794/focus=959493
> 
> These were waiting for Rusty's ACK.  They got ACKed today and will be
> pushed to mainline through percpu tree soonish.

OK. I just figured that I could initialize the rcu_heads in all cases in the
debugobject fixup anyway, so I guess I won't need "object_is_static()" after
all. But I can keep the patch around so it can eventually be re-sent to
standardize the debugobjects activation fixups. They currently need to keep a
flag around to identify statically defined objects.

Thanks,

Mathieu

> 
> Thanks.
> 
> -- 
> tejun

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
