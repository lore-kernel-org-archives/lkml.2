Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0KHGaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 01:30:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab0KHGaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:30:02 -0500
Date: Mon, 8 Nov 2010 07:29:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, Marcus Meissner <meissner@suse.de>,
        security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101108062916.GA31133@elte.hu>
References: <20101107085016.GA23843@elte.hu>
 <20101107094932.GT4627@1wt.eu>
 <20101107112709.GA2634@elte.hu>
 <20101107114156.GV4627@1wt.eu>
 <20101107114756.GB3759@elte.hu>
 <20101107115626.GX4627@1wt.eu>
 <20101107121235.GA6221@elte.hu>
 <20101107122227.GY4627@1wt.eu>
 <20101107123232.GB6512@elte.hu>
 <20101107152720.7e2c472e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107152720.7e2c472e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > This makes it _unsafe_ (for many types of attackers) to run an exploit locally.
> 
> They don't care.

Sure, script kiddies and botnet builders wont care - i.e. attacks where the 
individual target is low value, or where either the attacker or the attacked is 
stupid.

But it's different when a skilled attacker meets a skilled defense: all the 
exploits/attacks against high-value targets i've seen showed a great deal of care 
taken to avoid detection.

Future trends are also clear: eventually, as more and more of our lives are lived on 
the network, home boxes are becoming more and more valuable. So i think 
concentrating on the psychology of the skilled attacker would not be unwise. YMMV.

Thanks,

	Ingo
