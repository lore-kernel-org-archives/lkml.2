Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2HOR7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:59:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:39485 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab2HOR7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:59:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,774,1336374000"; 
   d="scan'208";a="181440923"
Message-ID: <502BE38D.9030405@linux.intel.com>
Date: Wed, 15 Aug 2012 10:59:41 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        vincent.guittot@linaro.org, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>   <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins>  <502BB5A3.5000403@linux.intel.com> <1345043096.31459.106.camel@twins>
In-Reply-To: <1345043096.31459.106.camel@twins>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 8:04 AM, Peter Zijlstra wrote:
> This all sounds far too complicated.. we're talking about simple
> spreading and packing balancers without deep arch knowledge and knobs,
> we couldn't possibly evaluate anything like that.
> 
> I was really more thinking of something useful for the laptops out
> there, when they pull the power cord it makes sense to try and keep CPUs
> asleep until the one that's awake is saturated.

as long as you don't do that on machines with an Intel CPU.. since that'd be
the worst case behavior for tasks that run for more than 100 usec.
(e.g. not interrupts, but almost everything else)




