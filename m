Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab2HPTVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:21:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:54198 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2HPTVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:21:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,780,1336374000"; 
   d="scan'208";a="181619566"
Message-ID: <502D481B.8010404@linux.intel.com>
Date: Thu, 16 Aug 2012 12:20:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
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
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com> <502CFD35.5000801@linux.intel.com> <502D3FB2.7000008@redhat.com>
In-Reply-To: <502D3FB2.7000008@redhat.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/2012 11:45 AM, Rik van Riel wrote:
> 
> The c-state governor can call the scheduler code before
> putting a CPU to sleep, to indicate (1) the wakeup latency
> of the CPU, and (2) whether TLB and/or cache get invalidated.

I don't think (2) is useful really; that basically always happens ;-)

