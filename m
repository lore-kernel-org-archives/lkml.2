Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2HUBGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:06:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:52395 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab2HUBGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:06:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,799,1336374000"; 
   d="scan'208";a="183320511"
Message-ID: <5032DED6.9090709@intel.com>
Date: Tue, 21 Aug 2012 09:05:26 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <20120815161911.GA14534@srcf.ucam.org> <502C7F24.6020900@intel.com> <CAKfTPtA98e8GYGwaj4k9y_-4h3e3UOguqJmdkqF0v3Y+5tPRpw@mail.gmail.com>
In-Reply-To: <CAKfTPtA98e8GYGwaj4k9y_-4h3e3UOguqJmdkqF0v3Y+5tPRpw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 11:47 PM, Vincent Guittot wrote:

> On 16 August 2012 07:03, Alex Shi <alex.shi@intel.com> wrote:
>> On 08/16/2012 12:19 AM, Matthew Garrett wrote:
>>
>>> On Mon, Aug 13, 2012 at 08:21:00PM +0800, Alex Shi wrote:
>>>
>>>> power aware scheduling), this proposal will adopt the
>>>> sched_balance_policy concept and use 2 kind of policy: performance, power.
>>>
>>> Are there workloads in which "power" might provide more performance than
>>> "performance"? If so, don't use these terms.
>>>
>>
>>
>> Power scheme should no chance has better performance in design.
> 
> A side effect of packing small tasks on one core is that you always
> use the core with the lowest C-state which will minimize the wake up
> latency so you can sometime get better results than performance mode
> which will try to use a other core in another cluster which will take
> more time to wake up that waiting for the end of the current task.
> 


Sure. some scenario packing tasks into smaller domain will bring
performance benefit.
