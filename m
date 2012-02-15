Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2BORia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:38:30 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53826 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2BORi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:38:29 -0500
Date: Wed, 15 Feb 2012 23:08:17 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: sched: Performance of Trade workload running inside VM
Message-ID: <20120215173817.GD9918@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
 <1329307161.2293.66.camel@twins>
 <20120215171032.GB9918@linux.vnet.ibm.com>
 <1329326651.2293.151.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329326651.2293.151.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12021507-5140-0000-0000-000000C06938
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-02-15 18:24:11]:

> On Wed, 2012-02-15 at 22:40 +0530, Srivatsa Vaddagiri wrote:
> > Ok ..let me see if these numbers highlight the problem better.
> 
> does this translate like: I've no fscking clue,

I'd mentioned a possible reason earlier which is limiting VM1 to reach higher
utilization (which is the time it waits for cpu after wakeup):

>b. In the "all VMs active" case, VM1's vcpu tasks were found to incur
>   "high" wait times when ttwo of VM1's tasks were scheduled on the same
>   CPU (i.e a VCPU task had to wait behind a sibling VCPU task for
>   obtaining CPU resource).

Let me get cpu wait time data and post it by tomorrow.

> but my tinker made it go away?

Do you have any other suggestions for me to try?

- vatsa

