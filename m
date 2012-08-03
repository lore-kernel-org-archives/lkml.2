Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2HCR0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:26:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:25595 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2HCR0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192964600"
Message-ID: <501C0966.3030007@linux.intel.com>
Date: Fri, 03 Aug 2012 10:24:54 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
References: <20120803163145.GA1549@gmail.com> <501C0273.2060603@linux.intel.com> <20120803170124.GA2773@gmail.com>
In-Reply-To: <20120803170124.GA2773@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/03/2012 10:01 AM, Ingo Molnar wrote:
> 
> * Darren Hart <dvhart@linux.intel.com> wrote:
> 
>> On 08/03/2012 09:31 AM, Ingo Molnar wrote:
>>> Linus,
>>>
>>> Please pull the latest core-urgent-for-linus git tree from:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus
>>>
>>>    HEAD: 6f7b0a2a5c0fb03be7c25bd1745baa50582348ef futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()
>>>
>>> Various futex fixes for bugs Darren Hart found via his 
>>> testsuite.
>>>
>>
>> Minor correction. I fixed two bugs reported by Dave Jones 
>> (found with his trinity test) and Dan Carpenter through static 
>> analysis. The other I found while debugging the first two. 
>> Credit where credit is due.
> 
> Hm, from the wording of the changelogs I thought you were 
> running those tests. Please put such bug reporting info into the 
> changelog and/or add a Reported-by tag next time around - 
> testers are our most valuable contributors.


I see the attribution of the testing I left only in the cover letter, my
apologies, sloppy of me.

I had followed Dave's request that I mention trinity and CC him on bugs
found with trinity - but looking at that patch now, it doesn't attribute
that well enough.

I'll correct this in the future.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
