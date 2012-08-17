Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab2HQSoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:44:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:65488 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab2HQSoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:44:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,785,1336374000"; 
   d="scan'208";a="210008597"
Message-ID: <502E90F3.2000702@linux.intel.com>
Date: Fri, 17 Aug 2012 11:44:03 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com> <502CFD35.5000801@linux.intel.com> <20120817184100.GA13369@srcf.ucam.org>
In-Reply-To: <20120817184100.GA13369@srcf.ucam.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/2012 11:41 AM, Matthew Garrett wrote:
> On Thu, Aug 16, 2012 at 07:01:25AM -0700, Arjan van de Ven wrote:
>>> *Power policy*:
>>>
>>> So how is power policy different? As Peter says,'pack more than spread
>>> more'.
>>
>> this is ... a dubiously general statement.
>>
>> for good power, at least on Intel cpus, you want to spread. Parallelism is efficient.
> 
> Is this really true? In a two-socket system I'd have thought the benefit 
> of keeping socket 1 in package C3 outweighed the cost of keeping socket 
> 0 awake for slightly longer.

not on Intel

you can't enter package c3 either until every one is down.
(e.g. memory controller must stay on etc etc)

