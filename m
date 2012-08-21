Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2HUPZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:25:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:55134 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab2HUPZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:25:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,802,1336374000"; 
   d="scan'208";a="189333803"
Message-ID: <5033A790.2060004@linux.intel.com>
Date: Tue, 21 Aug 2012 08:21:52 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <1345028738.31459.82.camel@twins> <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins> <502BB5A3.5000403@linux.intel.com> <1345043096.31459.106.camel@twins> <502BE38D.9030405@linux.intel.com> <20120820080606.GA6931@gmail.com> <20120820181651.GA737@srcf.ucam.org> <20120821094203.GB12385@gmail.com> <20120821113951.GA22436@srcf.ucam.org> <20120821151910.GA5359@gmail.com>
In-Reply-To: <20120821151910.GA5359@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> A modern kernel better know what state the system is in: on 
>>> battery or on AC power.
>>
>> That's a fundamentally uninteresting thing for the kernel to 
>> know about. [...]
> 
> I disagree.

and I'll agree with Matthew and disagree with you ;-)

> 
>> [...] AC/battery is just not an important power management 
>> policy input when compared to various other things.
> 
> Such as?
> 
> The thing is, when I use Linux on a laptop then AC/battery is 
> *the* main policy input.

I think you're wrong there.
First of all, not the whole world is a laptop.
Phones and servers are very different than laptops in this sense.
In a phone, when you're charging, you want to be EXTRA power efficient in many ways
(since charging creates heat, and that heat will take away your thermal budget).
In a datacenter, you're either on AC or DC all the time, and power efficiency still matters.

And even on a laptop.. heat production matters even when on AC... laptops are more and more like phones
that way.

