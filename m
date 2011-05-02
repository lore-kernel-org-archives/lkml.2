Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1EBIhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:37:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49093 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1EBIhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:37:12 -0400
Date: Mon, 2 May 2011 01:37:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@lnaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] Preview of RCU patches for 2.6.40
Message-ID: <20110502083705.GC2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <20110501161400.GA15035@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501161400.GA15035@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 09:14:01AM -0700, Josh Triplett wrote:
> On Sun, May 01, 2011 at 06:21:42AM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This patchset introduces RCU_TREE priority boosting, a new "fire and
> > forget" kfree_rcu() API, numerous uses of kfree_rcu(), plus a number
> > of other fixes and improvements.  The patches are as follows:
> 
> I replied to patches 7, 9, 17, 18, and 26 with some issues that need
> fixing.  For all the remaining patches (including others I replied to):
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you very much for your careful review and thoughtful comments!!!

							Thanx, Paul
