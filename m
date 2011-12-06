Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab1LFKiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:38:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134Ab1LFKiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:38:06 -0500
Date: Tue, 6 Dec 2011 11:36:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mm,x86: initialize high mem before free_all_bootmem()
Message-ID: <20111206103618.GE15966@elte.hu>
References: <1322582711-14571-1-git-send-email-sgruszka@redhat.com>
 <20111205110656.GA22259@elte.hu>
 <20111205150019.GA5434@redhat.com>
 <20111205155434.GD30287@elte.hu>
 <20111206075530.GA3105@redhat.com>
 <20111206080833.GB3105@redhat.com>
 <20111206082555.GA28314@elte.hu>
 <20111206102622.GC3105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206102622.GC3105@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Tue, Dec 06, 2011 at 09:25:55AM +0100, Ingo Molnar wrote:
> > The thing is, the pagealloc bug you fixed basically kept 
> > pagealloc debugging essentially disabled for a really long time, 
> > correct?
> Yes, it worked only in special cases.
>  
> > So i'd expect there to be quite a few latent problems - 
> > i'll give it some more testing before pushing out the result.
>
> Ehh, I expect them too, but fortunately only with 
> CONFIG_DEBUG_PAGEALLOC, non-debug kernel are not affected.

I test DEBUG_PAGEALLOC=y kernels all the time - i just booted a 
32-bit and a 64-bit allyesconfig kernel an hour ago.

Miraculously everything appears to be in working order so far.

Thanks,

	Ingo
