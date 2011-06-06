Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1FFO6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:58:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1FFO6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:58:38 -0400
Date: Mon, 6 Jun 2011 16:58:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606145827.GD30348@elte.hu>
References: <20110605110132.GB23463@elte.hu>
 <20110605111933.GA24592@elte.hu>
 <20110605113627.GA25724@elte.hu>
 <4DEB6F3A.3000109@die-jansens.de>
 <20110605133958.GA27812@elte.hu>
 <4DEB8A93.30601@die-jansens.de>
 <20110605141003.GB29338@elte.hu>
 <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <1307349530.2353.7374.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307349530.2353.7374.camel@twins>
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

> On Sun, 2011-06-05 at 17:13 +0200, Ingo Molnar wrote:
> 
> > Now, this patch alone just removes a debugging check - but i'm not 
> > sure the debugging check is correct - we take the pi_lock in a raw 
> > way - which means it's not lockdep covered.
> 
> Ever since tglx did s/raw_/arch_/g raw_ is covered by lockdep.

It's not lockdep covered due to the lockdep_off(), or am i missing 
something?

Thanks,

	Ingo
