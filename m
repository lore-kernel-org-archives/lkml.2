Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab2HPBVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:21:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:15563 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab2HPBVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:21:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,775,1336374000"; 
   d="scan'208";a="181589411"
Message-ID: <502C4B09.6070406@linux.intel.com>
Date: Wed, 15 Aug 2012 18:21:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>  <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins> <502BB5A3.5000403@linux.intel.com> <502C4973.6050901@redhat.com>
In-Reply-To: <502C4973.6050901@redhat.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 6:14 PM, Rik van Riel wrote:
> 
> The idea Matthew and I have is simply planning for a shorter
> sleep period (discarding the outliers to the high end in the
> function once known as detect_repeating_patterns), and going
> to a deeper C state if we have significantly overslept.
> 
> The new estimation code is easy, but for the past days I have
> been looking through the timer code to figure out how such a
> timer could fire, and how we could recognize it without it
> looking like a normal wakeup, if we do not end up accidentally
> waking up another CPU, etc...

this sort of code we recently developed already in house;
i'm surprised it hasn't been pasted to lkml yet


