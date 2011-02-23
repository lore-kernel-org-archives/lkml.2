Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1BWSws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:52:48 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46031 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330Ab1BWSwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:52:47 -0500
Date: Wed, 23 Feb 2011 10:52:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
	to kthread
Message-ID: <20110223185235.GR2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <BLU0-SMTP57EE20F30B92B8763FD2FE96DB0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP57EE20F30B92B8763FD2FE96DB0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:02:01AM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> [...]
> > +	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1)
> > +		if (mask & 01)
> 
> Wow, octal notation! ;)

/me pauses to thank the octal-notation PDP-12, CDC 3300, CDC Cyber 73,
and PDP-11 systems for funding my college education.  The two CDC
systems had ones-complement in the bargain.  ;-)

> Maybe we could consider 0x1 here.

Good catch, fixed.  The hex says "bitmask" to me.

							Thanx, Paul
