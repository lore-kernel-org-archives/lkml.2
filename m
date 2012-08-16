Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2HPFjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:39:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:34573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab2HPFjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:39:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,776,1336374000"; 
   d="scan'208";a="202365921"
Message-ID: <502C8798.8060807@intel.com>
Date: Thu, 16 Aug 2012 13:39:36 +0800
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
References: <5028F12C.7080405@intel.com> <20120815161911.GA14534@srcf.ucam.org> <502C7F24.6020900@intel.com> <20120816053133.GA31623@srcf.ucam.org>
In-Reply-To: <20120816053133.GA31623@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 01:31 PM, Matthew Garrett wrote:

> On Thu, Aug 16, 2012 at 01:03:32PM +0800, Alex Shi wrote:
>> On 08/16/2012 12:19 AM, Matthew Garrett wrote:
>>> Are there workloads in which "power" might provide more performance than 
>>> "performance"? If so, don't use these terms.
>>
>> Power scheme should no chance has better performance in design.
> 
> Power will tend to concentrate processes on packages, 


yes.

while performance 
> will tend to split them across packages?


No, there is still has balance idea in this rough proposal. If a domain
is not overload, it is better to left old tasks unchanged. I should say,
current scheduler is the 'performance' trend scheme.

 What if two cooperating 
> processes gain from being on the same package and sharing cache 
> locality?
> 

