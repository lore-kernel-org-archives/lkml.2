Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1EAXtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 19:49:17 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3444 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab1EAXtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 19:49:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMEAAvuvU15LHHJgWdsb2JhbACmGxUBARYmJYhxuEcOhXIEnS0
Date: Mon, 2 May 2011 09:49:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@lnaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] Preview of RCU patches for 2.6.40
Message-ID: <20110501234911.GI13542@dastard>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:21:42AM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This patchset introduces RCU_TREE priority boosting, a new "fire and
> forget" kfree_rcu() API, numerous uses of kfree_rcu(), plus a number
> of other fixes and improvements.  The patches are as follows:

.....

> 34-70.	Use kfree_rcu() throughout the kernel.  This set of patches has
> 	Acked-by's, so will go up -tip.
> 
> 71-86.	Ditto, but lacking Acked-by's.

Any reason why dentry and inode freeing was not converted in this
series?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
