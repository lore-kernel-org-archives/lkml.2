Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0ERQJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:09:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38613 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab0ERQJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:09:41 -0400
Date: Tue, 18 May 2010 18:08:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, benh@kernel.crashing.org, stable@kernel.org,
       tglx@linutronix.de, tony@bakeyournoodle.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] mutex: Fix optimistic spinning vs. BKL
Message-ID: <20100518160838.GA20658@elte.hu>
References: <20100507042010.GR12389@ozlabs.org>
 <tip-227945799cc10d77c6ef812f3eb8a61a78689454@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-227945799cc10d77c6ef812f3eb8a61a78689454@git.kernel.org>
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


* tip-bot for Tony Breeds <tony@bakeyournoodle.com> wrote:

> Commit-ID:  227945799cc10d77c6ef812f3eb8a61a78689454
> Gitweb:     http://git.kernel.org/tip/227945799cc10d77c6ef812f3eb8a61a78689454
> Author:     Tony Breeds <tony@bakeyournoodle.com>
> AuthorDate: Fri, 7 May 2010 14:20:10 +1000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 11 May 2010 17:07:24 +0200
> 
> mutex: Fix optimistic spinning vs. BKL

Tony, mind sending a version of this patch that does not 
include a jiffies based spinning loop?

Thanks,

	Ingo
