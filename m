Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2H3S41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:56:27 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55111 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2H3S4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:56:18 -0400
X-Originating-IP: 217.70.178.151
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 11:56:09 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/5] Documentation and rcutorture changes
Message-ID: <20120830185608.GA6749@jtriplet-mobl1>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830184448.GA31753@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:44:48AM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series covers changes to rcutorture and documentation updates.
> The individual patches in this series are as follows:
> 
> 1.	Update rcutorture default values so that casual rcutorture
> 	users will do more aggressive testing.
> 2.	Make rcutorture track CPU-hotplug latency statistics.
> 3.	Document SRCU's new-found ability to be used by offline and
> 	idle CPUs, and also emphasize SRCU's limitations.
> 4.	Use the new pr_*() interfaces in rcutorture.
> 5.	Prevent kthread-initialization races in rcutorture.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
>  b/Documentation/RCU/checklist.txt |    6 +
>  b/Documentation/RCU/whatisRCU.txt |    9 +-
>  b/kernel/rcutorture.c             |    4 -
>  kernel/rcutorture.c               |  152 +++++++++++++++++++++++---------------
>  4 files changed, 108 insertions(+), 63 deletions(-)

Something seems wrong with this diffstat; how'd the b/ prefixes get
there, and why does it list kernel/rcutorture.c twice, once with and
once without?

- Josh Triplett
