Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0HaOEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:04:16 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:59213 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757306Ab0HaOEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:04:13 -0400
Message-ID: <4C7D0B72.5050700@example.com>
Date: Tue, 31 Aug 2010 16:02:26 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
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
References: <20100828141637.421594670@chello.nl>	 <4C7923B4.6030208@example.com> <1283008225.1975.3598.camel@laptop>	 <4C79287B.9060609@example.com> <1283009031.1975.3615.camel@laptop> <4C7A56BC.6010705@example.com>
In-Reply-To: <4C7A56BC.6010705@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 825284632202604914
X-Ovh-Remote: 95.49.239.13 (afjf13.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.08.2010 14:46, Piotr Hosowicz wrote:
> On 28.08.2010 17:23, Peter Zijlstra wrote:
>> On Sat, 2010-08-28 at 17:17 +0200, Piotr Hosowicz wrote:
>>>> git remote add mmu_preempt
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git
>>>>
>>>> git remote update
>>>> git checkout mmu_preempt/mmu_preempt
>>>>
>>>> or
>>>>
>>>> git checkout -b mmu_preempt origin/master
>>>> git pull
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git
>>>> mmu_preempt
>>>
>>> Which is better? Thanks, I'll try.
>>
>> Fully depends on how you manage your git tree, the first will keep
>> giving you the same tree while the second will try and merge my changes
>> into whatever you got from Linus' tree, which keeps moving fwd and might
>> thus start failing (at which point I'll have to either rebase or
>> backmerge Linus' changes).
>
> I chose the second path, kernel built OK, but then I had to build NVidia
> module and I started Xorg. I logged in and then the screen froze for a
> while, then Kde background went black and I had to hard reset the PC,
> bezcause couldn't switch to VT. I attach my Xorg log.

Now I had done it the second way you described and everything seems to 
be working ok.

aapi205:~# uname -r
2.6.36-rc3-20100831-1507-pz+

If there will be any problems I'll write here.

Regards,

Piotr Hosowicz
-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Który aktor amerykañski jest mê¿em Nicole Kidman?
- Forrest Gump.
NP: Peter Green Splinter Group - You'll Be Sorry Someday
NB: 2.6.36-rc3-20100831-1507-pz+
