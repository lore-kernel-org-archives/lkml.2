Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2HTN02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:26:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:39804 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2HTN00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:26:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,797,1336374000"; 
   d="scan'208";a="188737347"
Message-ID: <50323AFD.7030802@linux.intel.com>
Date: Mon, 20 Aug 2012 06:26:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins> <502BB5A3.5000403@linux.intel.com> <1345043096.31459.106.camel@twins> <502BE38D.9030405@linux.intel.com> <20120820080606.GA6931@gmail.com>
In-Reply-To: <20120820080606.GA6931@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/2012 1:06 AM, Ingo Molnar wrote:
> 
> 
> There's also cases where the kernel has insufficient information 
> from the hardware and from the admin about the preferred 
> characteristics/policy of the system - a tweakable fallback knob 
> might be provided for that sad case.
> 
> The point is, that knob is not the policy setting and it's not 
> the main mechanism. It's a fallback.

if we call the knob "powersave", it better save power...
if we call it "group together" or "spread out".. no problem with that.




