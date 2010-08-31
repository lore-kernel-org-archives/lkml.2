Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0HaHtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:49:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832Ab0HaHtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:49:17 -0400
Date: Tue, 31 Aug 2010 09:49:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] memblock: Rename memblock_region to
 memblock_type and memblock_property to memblock_region
Message-ID: <20100831074907.GA1737@elte.hu>
References: <tip-e3239ff92a17976ac5d26fa0fe40ef3a9daf2523@git.kernel.org>
 <1282958776.1922.58.camel@pasglop>
 <20100831072947.GA32709@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831072947.GA32709@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2745]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > He, I was just about to rebase them :-)
> > 
> > Do you still need me to do that ?
> 
> Btw., because this is an older base, before we can push this to 
> linux-next i suspect we'll need fixes for those architectures that did 
> a memblock conversion in this cycle?

Here's the current state of things, with the x86 conversion in place and 
freshly merged up to v2.6.36-rc3:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/memblock

Any necessary changes due to new bits in .36-rc3 should be done now, 
before we progress any further.

Thanks,

	Ingo
