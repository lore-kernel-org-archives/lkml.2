Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab2HPFDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:03:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:3700 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab2HPFDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:03:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,776,1336374000"; 
   d="scan'208";a="134841028"
Message-ID: <502C7F24.6020900@intel.com>
Date: Thu, 16 Aug 2012 13:03:32 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <20120815161911.GA14534@srcf.ucam.org>
In-Reply-To: <20120815161911.GA14534@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 12:19 AM, Matthew Garrett wrote:

> On Mon, Aug 13, 2012 at 08:21:00PM +0800, Alex Shi wrote:
> 
>> power aware scheduling), this proposal will adopt the
>> sched_balance_policy concept and use 2 kind of policy: performance, power.
> 
> Are there workloads in which "power" might provide more performance than 
> "performance"? If so, don't use these terms.
> 


Power scheme should no chance has better performance in design.
