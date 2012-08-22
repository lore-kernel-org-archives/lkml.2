Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2HVNDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:03:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:42870 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab2HVNDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:03:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="189841223"
Message-ID: <5034D878.1000305@linux.intel.com>
Date: Wed, 22 Aug 2012 06:02:48 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <1345028738.31459.82.camel@twins>  <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins>  <502BB5A3.5000403@linux.intel.com> <1345043096.31459.106.camel@twins>  <502BE38D.9030405@linux.intel.com> <20120820080606.GA6931@gmail.com>  <20120820181651.GA737@srcf.ucam.org> <20120821094203.GB12385@gmail.com>  <20120821113951.GA22436@srcf.ucam.org> <20120821151910.GA5359@gmail.com>  <20120821170254.0b10ece6@pyramind.ukuu.org.uk> <1345614110.4374.65.camel@marge.simpson.net>
In-Reply-To: <1345614110.4374.65.camel@marge.simpson.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2012 10:41 PM, Mike Galbraith wrote:
> On Tue, 2012-08-21 at 17:02 +0100, Alan Cox wrote:
> 
>> I'd like to see actual numbers and evidence on a wide range of workloads
>> the spread/don't spread thing is even measurable given that you've also
>> got to factor in effects like completing faster and turning everything
>> off. I'd *really* like to see such evidence on a laptop,which is your
>> one cited case it might work.
> 
> For my dinky dual core laptop, I suspect you're right, but for a more
> powerful laptop, I'd expect spread/don't to be noticeable.

yeah if you don't spread, you will waste some power.
but.. current linux behavior is to spread.
so we can only make it worse.


> 
> Yeah, hard numbers would be nice to see.
> 
> If I had a powerful laptop, I'd kill irq balancing, and all but periodic
> load balancing, and expect to see a positive result. 

I'd expect to see a negative result ;-)

