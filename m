Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1DVT3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 15:29:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40734 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1DVT32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 15:29:28 -0400
Date: Fri, 22 Apr 2011 21:29:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Chris Samuel <chris@csamuel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad
 Pentium Pro system
Message-ID: <20110422192908.GA17975@elte.hu>
References: <201104222333.25546.chris@csamuel.org>
 <20110422134648.GB23965@elte.hu>
 <BANLkTin7mXkuUm=p49WJcw_PiFH5K7TsmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin7mXkuUm=p49WJcw_PiFH5K7TsmA@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> with Chris's config for 2.6.39-rc4, current tip tree says:
> 
> kernel/sched.c: In function ‘sched_init’:
> kernel/sched.c:7845:28: error: ‘load_balance_tmpmask’ undeclared
> (first use in this function)
> kernel/sched.c:7845:28: note: each undeclared identifier is reported
> only once for each function it appears in
> kernel/sched.c:7845:3: warning: type defaults to ‘int’ in type name
> kernel/sched.c:7845:28: warning: initialization makes pointer from
> integer without a cast
> kernel/sched.c:7845:3: warning: type defaults to ‘int’ in type name

Which sha1? It builds fine here on:

  ae1e16c: Merge branch 'perf/urgent'

Thanks,

	Ingo
