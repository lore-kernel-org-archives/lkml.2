Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1EGIQY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:16:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1EGIQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:16:18 -0400
Date: Sat, 7 May 2011 10:16:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, arnd@arndb.de,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] SCHED: Remove BKL accounting from schedstats
Message-ID: <20110507081602.GB25065@elte.hu>
References: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
 <1304715928-19266-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304715928-19266-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Remove the BKL accounting from schedstats.
> 
> I removed the field from the debug file too, in theory
> it could be kept as 0 for compatibility.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/sched.h |    4 ----
>  kernel/sched.c        |    6 ------
>  kernel/sched_debug.c  |    3 ---
>  3 files changed, 0 insertions(+), 13 deletions(-)

The thing is, and this is rather amazing: not a *single* patch in your patch 
series gets the patch title right ...

Andi, how hard is it for you to type 'git log kernel/sched.c' (and 'git log 
kernel/mutex.c', etc.) and see what the commit title convention the affected 
kernel subsystem has, and follow that convention, so that the maintainer does 
not have to edit every single patch of your series?

You are not a kernel newbie, you've been a kernel developer for how many years? 

You are showing an amazing level of inattention, which makes me very reluctant 
to even look at your patches, all of which touch tricky pieces of code.

You badly need to improve the quality of your patches. You could start that by 
feeding patches to a third party who knows how to submit patches upstream and 
who can sign off to them and forward them to the right maintainers.

Thanks,

	Ingo
