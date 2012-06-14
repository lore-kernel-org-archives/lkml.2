Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2FNOr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:47:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56669 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2FNOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:47:54 -0400
Date: Thu, 14 Jun 2012 07:47:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120614144734.GA2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
 <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
 <20120613204725.GA9858@linux.vnet.ibm.com>
 <20120614045125.GA30257@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141234400.3086@ionos>
 <20120614125939.GC2443@linux.vnet.ibm.com>
 <1339678887.2559.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339678887.2559.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061414-2398-0000-0000-0000077EE3B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 03:01:27PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-14 at 05:59 -0700, Paul E. McKenney wrote:
> > Yep, starvation.
> 
> What's the particular starvation case?

RCU callback processing consumes the entire CPU in RCU_BOOST case where
processing runs at real-time priority.  This is analogous to RT throttling
in the scheduler.

							Thanx, Paul

