Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0KGMNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:13:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab0KGMNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:13:14 -0500
Date: Sun, 7 Nov 2010 13:12:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107121235.GA6221@elte.hu>
References: <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
 <20101107085016.GA23843@elte.hu>
 <20101107094932.GT4627@1wt.eu>
 <20101107112709.GA2634@elte.hu>
 <20101107114156.GV4627@1wt.eu>
 <20101107114756.GB3759@elte.hu>
 <20101107115626.GX4627@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107115626.GX4627@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> [...]
>
> It's precisely because you're making a special case of the security bug that you 
> want to hide bugs from user-space by cheating on version.

You claimed this for the second time and i'm denying it for the second time.

The goal of fuzzing the version inforation is _not_ to 'hide bugs from user-space by 
cheating on version'. The goal is to introduce uncertainty to attackers, so that a 
honeypot silent alarm can warn the admin.

Why are you putting words in my mouth?

Thanks,

	Ingo
