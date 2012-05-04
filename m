Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab2EDACc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:02:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:4971 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946Ab2EDACb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:02:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161690213"
Subject: Re: [RFC][PATCH 1/5] sched, fair: Let minimally loaded cpu balance
 the group
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@kernel.org, pjt@google.com,
        efault@gmx.de, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 17:05:45 -0700
In-Reply-To: <20120502103453.GB22740@linux.vnet.ibm.com>
References: <20120501181430.007891123@chello.nl>
	 <20120501182610.745844312@chello.nl>
	 <20120502102541.GA22740@linux.vnet.ibm.com>
	 <1335954690.13683.178.camel@twins>
	 <20120502103453.GB22740@linux.vnet.ibm.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336089945.28674.460.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 16:04 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-05-02 12:31:30]:
> 
> > > IOW :
> > > 
> > > 		balance_load = 0 iff idle_cpu(i) ??
> > 
> > I think so, even for !0 load_idx, load will only reach zero when we're
> > idle, just takes longer.
> 
> Right ...so should we force it to select a idle_cpu by having
> balance_load = 0 for a idle cpu (ignoring what target_load(i, load_idx)
> told us as its load?

I think Peter is trying to find the leastly loaded among idle cpu's (in
other words the longest idle cpu ;)

should be ok, isn't it?

thanks,
suresh



