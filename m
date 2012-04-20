Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2DTQko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:40:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:35860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229Ab2DTQkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="132143700"
Subject: Re: load balancing regression since commit 367456c7
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1334930421.2463.60.camel@laptop>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>  <1334681054.3796.28.camel@schen9-DESK>
	 <1334930421.2463.60.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 09:40:42 -0700
Message-ID: <1334940042.3796.48.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 16:00 +0200, Peter Zijlstra wrote:

> 
> Ok, so I can't reproduce this on my WSM-EP.. even !PREEMPT kernels are
> consistent with hackbench times with or without that patch.
> 
> Can you still send your full .config? Also, do you have cpu-cgroup muck
> enabled and are you using that systemd shite?
> 
> What does the below patch (on top of the previous) do?
> 

There is a slight 10% to 15% improvement with the patch.  However,
the change in performance difficult to quantify precisely as the 
hackbench runtime has large variations (up to 50%) on our Sandy Bridge EP
server machines since commit 367456c7.

We also do not see regression for hackbench on WSM-EP, but only 
on machines with Sandy-Bridge EP (2 socket, 8 cores/socket, HT enabled).  
We are not running hackbench in cgroup for this test.

The Sandy Bridge EP machines installed has FC16, so I think it uses 
systemd. The machine on our WSM EP has FC15, which also has systemd.

I'm sending you the .config in a separate mail.  Thanks for taking a look.
The .config aligns closely with standard Fedora settings.

Tim


