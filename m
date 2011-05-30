Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1E3MOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:14:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36649 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1E3MOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:14:30 -0400
Date: Mon, 30 May 2011 14:14:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@MIT.EDU>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530121415.GG22324@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
 <alpine.LFD.2.02.1105301255560.3164@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105301255560.3164@localhost6.localdomain6>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 30 May 2011, Theodore Tso wrote:
> 
> > OK, so to clarify, what you want is for ARCH=xxx to always override
> > whatever is in .config?  Are we all on the same page here?  I thought
> > David was arguing that what was in .config should always be more
> > important, since he regards "ARCH=xxxx" as "legacy".
> 
> I am saying that we should not have that redundancy at all. ATM we *only* 
> have it for CONFIG_64BIT and *only* on x86, not others like ppc/sh/sparc 
> etc.

Even if we were ready to remove a feature that is 'only' available on 
90%+ of development systems that kernel developers use today, we 
probably couldn't do it due to the upstream kernel regression policy 
anyway. Especially when there is no functionally equivalent 
replacement.

Thanks,

	Ingo
