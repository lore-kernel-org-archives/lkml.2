Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915Ab1EAQOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:14:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51516 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1EAQOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:14:20 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 50.43.15.19
Date: Sun, 1 May 2011 09:14:01 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@lnaro.org
Subject: Re: [PATCH tip/core/rcu 0/6] Preview of RCU patches for 2.6.40
Message-ID: <20110501161400.GA15035@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:21:42AM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This patchset introduces RCU_TREE priority boosting, a new "fire and
> forget" kfree_rcu() API, numerous uses of kfree_rcu(), plus a number
> of other fixes and improvements.  The patches are as follows:

I replied to patches 7, 9, 17, 18, and 26 with some issues that need
fixing.  For all the remaining patches (including others I replied to):

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
