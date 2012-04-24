Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2DXRIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:08:09 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58883 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2DXRIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:08:06 -0400
Date: Tue, 24 Apr 2012 22:37:43 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better
 latencies
Message-ID: <20120424170743.GA18799@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120424165619.GA28701@linux.vnet.ibm.com>
 <1335286696.28150.206.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1335286696.28150.206.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12042417-5816-0000-0000-00000246D00A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-04-24 18:58:16]:

> On Tue, 2012-04-24 at 22:26 +0530, Srivatsa Vaddagiri wrote:
> > Steer a waking task towards a cpu where its cgroup has zero tasks (in
> > order to provide it better sleeper credits and hence reduce its wakeup
> > latency). 
> 
> That's just vile.. pjt could you post your global vruntime stuff so
> vatsa can have a go at that?

The workload I am up against does experience tons of wakeup (after very short 
(microsecond range) bursts of sleeps) and so am skeptical how the global 
vruntime would keep up with this kind of workload. I'd be happy to test patches 
and give feedback!

- vatsa

