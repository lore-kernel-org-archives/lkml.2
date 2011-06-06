Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab1FFWIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:08:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59176 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1FFWIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:08:22 -0400
Date: Tue, 7 Jun 2011 00:08:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606220806.GC12079@elte.hu>
References: <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu>
 <1307378649.2322.198.camel@twins>
 <20110606171153.GE2391@elte.hu>
 <4DED1519.2020803@die-jansens.de>
 <20110606180733.GA20123@elte.hu>
 <1307384349.2497.732.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307384349.2497.732.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2011-06-06 at 20:07 +0200, Ingo Molnar wrote:
> 
> >  - The first one that minimally removes the lockdep_off()/on() dance 
> >    and fixes the regression: the patch that i sent earlier today.
> >    I *think* that should fix the crash.
> > 
> >    3.0 material.
> 
> I think the lock_is_held() fix is the urgent one, all the others are
> make printk() suck less patches, ie. not so very important.
> 
> Without that lock_is_held() thing all lockdep_off() sites, inc ntfs will
> still be able to trigger this problem.

ok. Could you please send a changeloggified patch with a 
Reported-and-tested-by from Arne in a new thread, etc?

Thanks,

	Ingo
