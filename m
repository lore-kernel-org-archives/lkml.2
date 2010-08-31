Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0HaHaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:30:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096Ab0HaH36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:29:58 -0400
Date: Tue, 31 Aug 2010 09:29:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] memblock: Rename memblock_region to
 memblock_type and memblock_property to memblock_region
Message-ID: <20100831072947.GA32709@elte.hu>
References: <tip-e3239ff92a17976ac5d26fa0fe40ef3a9daf2523@git.kernel.org>
 <1282958776.1922.58.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282958776.1922.58.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0342]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sat, 2010-08-28 at 00:37 +0000, tip-bot for Benjamin Herrenschmidt
> wrote:
> > Commit-ID:  e3239ff92a17976ac5d26fa0fe40ef3a9daf2523
> > Gitweb:     http://git.kernel.org/tip/e3239ff92a17976ac5d26fa0fe40ef3a9daf2523
> > Author:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > AuthorDate: Wed, 4 Aug 2010 14:06:41 +1000
> > Committer:  Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CommitDate: Wed, 4 Aug 2010 14:21:49 +1000
> > 
> > memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region
> 
> He, I was just about to rebase them :-)
> 
> Do you still need me to do that ?

Btw., because this is an older base, before we can push this to 
linux-next i suspect we'll need fixes for those architectures that did a 
memblock conversion in this cycle?

Thanks,

	Ingo
