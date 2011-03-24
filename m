Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab1CXRWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:22:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab1CXRWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:22:12 -0400
Date: Thu, 24 Mar 2011 18:21:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: torvalds@linux-foundation.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324172155.GD2414@elte.hu>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
 <20110324142146.GA11682@elte.hu>
 <20110324160310.GA27127@elte.hu>
 <20110324161446.GA32068@elte.hu>
 <AANLkTimppcCuKYPQjRhEhRyRUNZ06NxZ_SMVYhem3ur2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimppcCuKYPQjRhEhRyRUNZ06NxZ_SMVYhem3ur2@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Mar 24, 2011 at 6:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > The combo revert below solves the boot crash.
> >
> > Thanks,
> >
> >        Ingo
> >
> > ------------------------------->
> > From 1b322eee05a96e8395b62e04a3d1f10fb483c259 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 24 Mar 2011 17:03:51 +0100
> > Subject: [PATCH] Revert various slub patches
> >
> > Revert "slub: Add missing irq restore for the OOM path"
> >
> > This reverts commit 2fd66c517d5e98de2528d86e0e62f5069ff99f59.
> >
> > Revert "slub: Dont define useless label in the !CONFIG_CMPXCHG_LOCAL case"
> >
> > This reverts commit a24c5a0ea902bcda348f086bd909cc2d6e305bf8.
> >
> > Revert "slub,rcu: don't assume the size of struct rcu_head"
> >
> > This reverts commit da9a638c6f8fc0633fa94a334f1c053f5e307177.
> 
> Btw, this RCU commit is unrelated. It just happens to have a merge
> conflict with the lockless patches which is why you needed to revert
> it.

Yeah - this was just a brute-force combo patch to remove the buggy commit.

Thanks,

	Ingo
