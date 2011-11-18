Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1KRXKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:10:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:36748 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab1KRXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:10:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77564180"
Message-Id: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 15:03:23 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
Subject: [patch 0/6] sched, nohz: load balancing patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the -v2 of the load balancing patches that makes nohz idle
load balancing more scalabale. While the last 2 in the series are not
directly related to nohz, I clubbed them as part of this series as I noticed
them while I was working in this area and they helped the context switch
intensive workloads improve on the 8-socket system.

Previous RFC version of this can be found at
https://lkml.org/lkml/2011/11/1/368

thanks,
suresh

