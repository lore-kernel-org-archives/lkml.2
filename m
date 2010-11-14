Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0KNJ4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 04:56:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab0KNJ41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 04:56:27 -0500
Date: Sun, 14 Nov 2010 10:56:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Kees Cook <kees.cook@canonical.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] proactive defense: using read-only memory, RO/NX
 modules
Message-ID: <20101114095612.GA27411@elte.hu>
References: <20101107193520.GO5327@outflux.net>
 <20101108061324.GA30540@elte.hu>
 <20101108214228.GQ5876@outflux.net>
 <20101110090415.GC8370@elte.hu>
 <4CDEEE33.3050106@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDEEE33.3050106@free.fr>
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


* matthieu castet <castet.matthieu@free.fr> wrote:

> If you want I can repost things or port it to new kernel.

Yes, please post it against latest -tip:

   http://people.redhat.com/mingo/tip.git/README

(Please also Cc: everyone who expressed interest in the topic in this thread.)

Thanks,

	Ingo
