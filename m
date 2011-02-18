Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1BRB0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:26:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:10302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1BRB0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:26:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,183,1297065600"; 
   d="scan'208";a="390515590"
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: "Alex,Shi" <alex.shi@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	 <1296854731-25039-1-git-send-email-venki@google.com>
	 <1297086642.13327.15.camel@laptop>
	 <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
	 <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1297266928.13327.216.camel@laptop>
	 <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 09:05:53 +0800
Message-ID: <1297991153.14712.636.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I am also ok with removing this code. But as Venki mentioned earlier
> (http://marc.info/?l=linux-kernel&m=129735866732171&w=2), we need to
> make sure idle core gets priority instead of an idle smt-thread on a
> busy core while pulling the load from the busiest socket.
> 
> I requested Venki to post these 2 patches of removing the propagation of
> busy sibling status to an idle sibling and prioritizing the idle core
> while pulling the load. I will request Alex and Tim to run their
> performance workloads to make sure that this doesn't show any
> regressions.

I have got sd_idle deletion and other patches. So just tested this v1
patch based on 38-rc4 kernel on WSM-EP NHM-EP, and Core2 machine, didn't
find clear performance regression or improvement, include on
hackbench/specjbb/volano etc. 

> 
> thanks,
> suresh
> 


