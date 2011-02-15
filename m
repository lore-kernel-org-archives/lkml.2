Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1BOTLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:11:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:41294 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab1BOTLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:11:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,475,1291622400"; 
   d="scan'208";a="708151113"
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Shi, Alex" <alex.shi@intel.com>
In-Reply-To: <1297761326.2401.14.camel@twins>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	 <1296854731-25039-1-git-send-email-venki@google.com>
	 <1297086642.13327.15.camel@laptop>
	 <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
	 <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1297266928.13327.216.camel@laptop>
	 <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1297761326.2401.14.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 15 Feb 2011 11:11:29 -0800
Message-Id: <1297797089.2806.1599.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 01:15 -0800, Peter Zijlstra wrote:
> On Fri, 2011-02-11 at 17:20 -0800, Suresh Siddha wrote:
> > I will request Alex and Tim to run their
> > performance workloads to make sure that this doesn't show any
> > regressions.
> 
> Are those workloads public? If so which are they?
> 
> It would be good if all of us working on this could use them.. :-)

http://kernel-perf.sourceforge.net/about_tests.php

thanks,
suresh


