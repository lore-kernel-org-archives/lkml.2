Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab2HWIUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:20:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:6264 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030253Ab2HWIT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,299,1344236400"; 
   d="scan'208";a="190309875"
Message-ID: <5035E77A.4010107@intel.com>
Date: Thu, 23 Aug 2012 16:19:06 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <20120820080606.GA6931@gmail.com> <20120820181651.GA737@srcf.ucam.org> <20120821094203.GB12385@gmail.com> <20120821113951.GA22436@srcf.ucam.org> <20120821151910.GA5359@gmail.com> <20120821152828.GB28241@srcf.ucam.org> <20120821155908.GA5499@gmail.com> <20120821161324.GA29665@srcf.ucam.org> <20120821182346.GA7325@gmail.com> <20120821183414.GA436@srcf.ucam.org> <20120822091013.GB23336@gmail.com>
In-Reply-To: <20120822091013.GB23336@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 05:10 PM, Ingo Molnar wrote:

> 
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
>> [...]
>>
>> Our power consumption is worse than under other operating 
>> systems is almost entirely because only one of our three GPU 
>> drivers implements any kind of useful power management. [...]
> 
> ... and because our CPU frequency and C state selection logic is 
> doing pretty much the worst possible decisions (on x86 at 
> least).
> 
> Regardless, you cannot possibly seriously suggest that because 
> there's even greater suckage elsewhere for some workloads we 
> should not even bother with improving the situation here.
> 
> Anyway, I agree with Alan that actual numbers matter.


Sure. we'd better make ideas into code, and then let benchmarks and data
speaking.

> 
> Thanks,
> 
> 	Ingo


