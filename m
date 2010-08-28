Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0H1PS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:18:56 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:42892 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752269Ab0H1PSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:18:54 -0400
Message-ID: <4C79287B.9060609@example.com>
Date: Sat, 28 Aug 2010 17:17:15 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
References: <20100828141637.421594670@chello.nl>	 <4C7923B4.6030208@example.com> <1283008225.1975.3598.camel@laptop>
In-Reply-To: <1283008225.1975.3598.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2917488135556067727
X-Ovh-Remote: 83.24.91.204 (dnj204.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.500001/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.08.2010 17:10, Peter Zijlstra wrote:
> On Sat, 2010-08-28 at 16:56 +0200, Piotr Hosowicz wrote:
>> On 28.08.2010 16:16, Peter Zijlstra wrote:
>>
>>> Full series (including the Sparc64 gup_fast bits) also available in -git
>>> form from (against Linus' tree as of about an hour ago):
>>
>> How come? I tried this:
>>
>> aapi205:/usr/src/linus/tmp# git pull
>> Already up-to-date.
>>
>> ... and don't see an update. Maybe I don't do something right. If there
>> is newer code I should receive it, am I correct? I use this link:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>
> That's Linus' tree, the patches aren't in there quite yet, try:
>
>    git remote add mmu_preempt git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git
>    git remote update
>    git checkout mmu_preempt/mmu_preempt
>
> or
>
>    git checkout -b mmu_preempt origin/master
>    git pull git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git mmu_preempt

Which is better? Thanks, I'll try.

Regards,

Piotr Hosowicz

-- 
Wzór Einsteina-Pitagorasa: E = mc2 = m(a2 + b2)
NP: Peter Green Splinter Group - Big Change Is Gonna Come
NB: 2.6.36-rc2-next-20100827
