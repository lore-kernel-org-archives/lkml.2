Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2FNIiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:38:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:48040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2FNIiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:38:11 -0400
Message-ID: <1339663081.2559.11.camel@twins>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jun 2012 10:38:01 +0200
In-Reply-To: <alpine.LFD.2.02.1206141036310.3086@ionos>
References: <20120613102823.373180763@linutronix.de>
	  <20120613105815.206105518@linutronix.de>
	  <20120613183301.GE2427@linux.vnet.ibm.com>
	  <alpine.LFD.2.02.1206132050270.3086@ionos> <1339661331.2559.5.camel@twins>
	 <alpine.LFD.2.02.1206141036310.3086@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 10:37 +0200, Thomas Gleixner wrote:
> On Thu, 14 Jun 2012, Peter Zijlstra wrote:
> 
> > On Wed, 2012-06-13 at 20:56 +0200, Thomas Gleixner wrote:
> > > If it's just a spurious wakeup then it goes back to sleep right away
> > > as nothing cleared the park bit. 
> > 
> > Your spurious wakeup will have destroyed the binding though. So you need
> > to be careful.
> 
> We explicitely rebind it on unpark().

OK, no worries then.
