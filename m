Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0ICGZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:25:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0ICGZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:25:11 -0400
Date: Fri, 3 Sep 2010 08:21:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
        linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, kmemcheck: Remove double test
Message-ID: <20100903062150.GC19074@elte.hu>
References: <1283010066-20935-5-git-send-email-julia@diku.dk>
 <tip-9fbaf49c7f717740002d49eee1bbd03d89d8766a@git.kernel.org>
 <AANLkTi=-7Dq09Svwo9nwYA4xzZx4NJapPigW6SodF6g4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=-7Dq09Svwo9nwYA4xzZx4NJapPigW6SodF6g4@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On 30 August 2010 10:36, tip-bot for Julia Lawall <julia@diku.dk> wrote:
> > Commit-ID:  9fbaf49c7f717740002d49eee1bbd03d89d8766a
> > Gitweb:     http://git.kernel.org/tip/9fbaf49c7f717740002d49eee1bbd03d89d8766a
> > Author:     Julia Lawall <julia@diku.dk>
> > AuthorDate: Sat, 28 Aug 2010 17:41:03 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 30 Aug 2010 09:19:28 +0200
> >
> > x86, kmemcheck: Remove double test
> >
> > The opcodes 0x2e and 0x3e are tested for in the first Group 2
> > line as well.
> >
> > The sematic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @expression@
> > expression E;
> > @@
> >
> > (
> > * E
> >  || ... || E
> > |
> > * E
> >  && ... && E
> > )
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Vegard Nossum <vegardno@ifi.uio.no>
> > LKML-Reference: <1283010066-20935-5-git-send-email-julia@diku.dk>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/mm/kmemcheck/opcode.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> 
> Sorry, was a bit late.
> 
> Thanks for the patch, review, and picking up :-)

You are welcome :)

	Ingo
