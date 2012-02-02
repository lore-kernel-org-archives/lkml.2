Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2BBRe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:34:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47389 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab2BBRbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:25 -0500
Date: Thu, 2 Feb 2012 09:30:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC tip/core/rcu 21/41] rcu: Inform RCU of irq_exit()
 activity
Message-ID: <20120202173039.GR2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-21-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202023033.GN29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202023033.GN29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-2398-0000-0000-000003E31779
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 06:30:33PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:39AM -0800, Paul E. McKenney wrote:
> > [ Alternatively, delaying the ->rcu_read_lock_nesting decrement
> >   until after the special handling would make the thing more robust
> >   in the face of interrupts as well.  And there is a separate patch
> >   for that. ]
> 
> Where does that separate patch live, and should it replace this one?

It is #18 in this series: "rcu: Protect __rcu_read_unlock() against
scheduler-using irq handlers".  Both are needed.  I will rework the
commit message appropriately.

							Thanx, Paul

