Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2BWIhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:37:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2BWIhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:37:20 -0500
Date: Thu, 23 Feb 2012 09:37:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: Re: [tip:perf/core] x86/kprobes: Fix to recover instructions on
 optimized path
Message-ID: <20120223083703.GA26781@elte.hu>
References: <20120221083621.11350.4716.stgit@localhost.localdomain>
 <tip-f5dbbb8e1e055d6f02817a1995993b461910b1b7@git.kernel.org>
 <20120222162224.GA5256@elte.hu>
 <4F459941.1000006@hitachi.com>
 <20120223070747.GA14495@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120223070747.GA14495@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > Does not build on x86 if CONFIG_OPTPROBES is off:
> > > 
> > > arch/x86/kernel/kprobes.c:260:8: error: dereferencing pointer to incomplete type
> > > arch/x86/kernel/kprobes.c:260:8: error: invalid use of undefined type ‘struct optimized_kprobe’
> > > arch/x86/kernel/kprobes.c:262:22: error: dereferencing pointer to incomplete type
> > > arch/x86/kernel/kprobes.c:264:18: error: dereferencing pointer to incomplete type
> > 
> > Oops, should I update this patch or send new diff?
> 
> Please send a delta fix.

Hm, it was triggering too often so I removed it from perf:core 
for now - please send an updated patch.

Please also pick up the slightly updated changelog I've created 
for the commit - you can see it in the -tip notification email.

Btw., why are optprobes limited to !PREEMPT, could we make them 
preempt safe?

Thanks,

	Ingo
