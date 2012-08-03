Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2HCQ5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:57:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:9003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab2HCQ5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:57:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192954763"
Message-ID: <501C0273.2060603@linux.intel.com>
Date: Fri, 03 Aug 2012 09:55:15 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
References: <20120803163145.GA1549@gmail.com>
In-Reply-To: <20120803163145.GA1549@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/03/2012 09:31 AM, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest core-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus
> 
>    HEAD: 6f7b0a2a5c0fb03be7c25bd1745baa50582348ef futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()
> 
> Various futex fixes for bugs Darren Hart found via his 
> testsuite.
> 

Minor correction. I fixed two bugs reported by Dave Jones (found with
his trinity test) and Dan Carpenter through static analysis. The other
I found while debugging the first two. Credit where credit is due.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
