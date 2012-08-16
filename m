Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2HPN5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:57:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:33721 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab2HPN5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:57:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="181797557"
Message-ID: <502CFC41.1030501@linux.intel.com>
Date: Thu, 16 Aug 2012 06:57:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <20120815161911.GA14534@srcf.ucam.org> <502C7F24.6020900@intel.com>
In-Reply-To: <502C7F24.6020900@intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 10:03 PM, Alex Shi wrote:
> On 08/16/2012 12:19 AM, Matthew Garrett wrote:
> 
>> On Mon, Aug 13, 2012 at 08:21:00PM +0800, Alex Shi wrote:
>>
>>> power aware scheduling), this proposal will adopt the
>>> sched_balance_policy concept and use 2 kind of policy: performance, power.
>>
>> Are there workloads in which "power" might provide more performance than 
>> "performance"? If so, don't use these terms.
>>
> 
> 
> Power scheme should no chance has better performance in design.

ehm.....

so in reality, the very first thing that helps power, is to run software efficiently.

anything else is completely secondary.

if placement policy leads to a placement that's different from the most efficient placement,
you're already burning extra power...

