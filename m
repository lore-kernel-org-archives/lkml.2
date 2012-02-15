Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2BORpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:45:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59100 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2BORpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:45:11 -0500
Message-ID: <1329327902.2293.168.camel@twins>
Subject: Re: sched: Performance of Trade workload running inside VM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 18:45:02 +0100
In-Reply-To: <20120215173817.GD9918@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
	 <1329307161.2293.66.camel@twins> <20120215171032.GB9918@linux.vnet.ibm.com>
	 <1329326651.2293.151.camel@twins>
	 <20120215173817.GD9918@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 23:08 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-02-15 18:24:11]:
> 
> > On Wed, 2012-02-15 at 22:40 +0530, Srivatsa Vaddagiri wrote:
> > > Ok ..let me see if these numbers highlight the problem better.
> > 
> > does this translate like: I've no fscking clue,
> 
> I'd mentioned a possible reason earlier which is limiting VM1 to reach higher
> utilization (which is the time it waits for cpu after wakeup):
> 
> >b. In the "all VMs active" case, VM1's vcpu tasks were found to incur
> >   "high" wait times when ttwo of VM1's tasks were scheduled on the same
> >   CPU (i.e a VCPU task had to wait behind a sibling VCPU task for
> >   obtaining CPU resource).
> 
> Let me get cpu wait time data and post it by tomorrow.
> 
> > but my tinker made it go away?
> 
> Do you have any other suggestions for me to try?

I'm still waiting for a problem description that isn't a book.

What does the load-balancer do, why is it wrong, why does your patch
sort it etc.

I've really no idea what you're trying to do, other than make your
numbers improve (which while a noble goal, doesn't help in judging your
patch or suggesting alternative means of getting there).
