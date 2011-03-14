Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab1CNBPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:15:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:32314 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139Ab1CNBPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:15:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,312,1297065600"; 
   d="scan'208";a="402036677"
Message-ID: <4D7D6C40.3020807@linux.intel.com>
Date: Sun, 13 Mar 2011 18:15:44 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Darren Hart <darren@dvhart.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] futex: do not pagefault_disable in futex_atomic_cmpxchg_inatomic()
References: <20110307021127.GB31188@google.com>	<alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>	<20110309112550.GA3050@google.com>	<alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>	<20110311021654.GA26122@google.com>	<20110311024731.GB26122@google.com>	<AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com> <AANLkTinmxcjRUj-JRtmO3JSAGWoiW+ec7JzTBpL32C=t@mail.gmail.com>
In-Reply-To: <AANLkTinmxcjRUj-JRtmO3JSAGWoiW+ec7JzTBpL32C=t@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 05:55 PM, Darren Hart wrote:
> I have to apologize. These landed right as I was leaving for OSTS and
> I didn't have time to review them properly.  I wondered about the
> preempt vs pagefault disable and wondered how exit_robust_list() was
> covered in Michel's comments (perhaps somewhere higher up the call
> chain). I leaned on the review of others when I should have raised the
> questions even if I didn't have the time to dig into them myself.
> Linus shouldn't have had to raise those questions, I'll do better at
> this in the future.
>
> I noticed that my name is the only one in futex.c with an email
> address in the header

Scratch that, the others are just on the Copyright line instead of the 
feature line. What is the policy for updating email addresses in source 
files? With git, I suppose they are no longer particularly useful. 
Should I remove a bad address, or just learn from it and not include it 
in future work?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
