Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1GYUHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:07:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab1GYUHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:07:39 -0400
Date: Mon, 25 Jul 2011 22:06:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110725200645.GC8302@elte.hu>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
 <20110724182323.GA13247@aftab>
 <20110724183045.GB29660@elte.hu>
 <20110724190752.GA13647@aftab>
 <20110724204450.GB18546@elte.hu>
 <20110725200014.GA23986@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725200014.GA23986@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Borislav Petkov <bp@amd64.org> wrote:

> So yeah, the simpler fix works for processes mapping libraries in 
> the same order but not for processes mapping a subset of libraries 
> in a different order.

but what is the proportion of 'good' versus bad alignment of 
libraries, could you collect some stats on a representative enough, 
fully booted up Linux system?

Are only 1% of mappings 'bad'? 5%? 10%? 50%? We have no idea and the 
actual number matters a lot.

Thanks,

	Ingo
