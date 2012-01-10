Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2AJDhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 22:37:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:42754 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2AJDhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 22:37:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94131528"
Date: Tue, 10 Jan 2012 11:54:26 -0500
From: Youquan Song <youquan.song@intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Youquan Song <youquan.song@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120110165426.GA20681@linux-youquan.bj.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com> <1326103578.2442.50.camel@twins> <20120110001445.GA20542@linux-youquan.bj.intel.com> <1326107156.2442.59.camel@twins> <20120110055856.GA23741@linux-youquan.bj.intel.com> <1326153163.2366.7.camel@sbsiddha-mobl2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326153163.2366.7.camel@sbsiddha-mobl2>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Youquan, As far as I know both the
> sched_smt_power_savings/sched_mc_power_savings are broken for atleast an
> year.
> 
> Have you checked the state of 'sched_mc_power_savings' to see if it is
> working or gets addressed with your proposed patches?
Thanks Suresh!

We have verified that sched_mc_power_savings works well in mainline and
-tip tree, only sched_smt_power_savings broken.

Sorry. My proposed patch last night still need be refreshed. After I closely look
at SD_PREFER_SIBLING logic, there is possible a fighting which Peter has
mentioned it.

I will post a update patch soon.

-Youquan 

