Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1EGJkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 05:40:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55247 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1EGJkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 05:40:21 -0400
Date: Sat, 7 May 2011 11:40:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Makefile: Use gcc to determine ARCH
Message-ID: <20110507094006.GH27657@elte.hu>
References: <1304743274.3132.17.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304743274.3132.17.camel@localhost>
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


* Lin Ming <ming.m.lin@intel.com> wrote:

> The original Makefile uses "uname -m" to determine ARCH.
> This causes problem on x86 when compile perf tool on 32 bit userspace
> with a 64 bit kernel.
> 
> bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
> bench/../../../arch/x86/lib/memcpy_64.S:28: Error: bad register name `%rdi'
> 
> This is because "uname -m" returns x86_64 and memcpy_64.S is included in 32 bit build.
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

this changelog is missing an important line:

 Reported-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>

I've added it.

Thanks,

	Ingo
