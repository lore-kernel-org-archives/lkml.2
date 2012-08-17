Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2HQBaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:30:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:43598 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab2HQBaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:30:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,782,1336374000"; 
   d="scan'208";a="203168962"
Message-ID: <502D9E78.5010403@intel.com>
Date: Fri, 17 Aug 2012 09:29:28 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: preeti <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com> <502CFD35.5000801@linux.intel.com>
In-Reply-To: <502CFD35.5000801@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 10:01 PM, Arjan van de Ven wrote:

>> *Power policy*:
>>
>> So how is power policy different? As Peter says,'pack more than spread
>> more'.
> 
> this is ... a dubiously general statement.
> 
> for good power, at least on Intel cpus, you want to spread. Parallelism is efficient.
> 
> the only thing you do not want to do, is wake cpus up for
> tasks that only run extremely briefly (think "100 usec" or less).


It's a very important and valuable info!
Just want to know how you get this? From CS cost or cache/TLB refill cost?

> 
> so maybe the balance interval is slightly different, or more, you don't balance tasks that
> historically ran only for brief periods
> 
> 


