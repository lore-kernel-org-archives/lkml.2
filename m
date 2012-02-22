Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2BVQWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:22:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44362 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2BVQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:22:46 -0500
Date: Wed, 22 Feb 2012 17:22:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86/kprobes: Fix to recover instructions on
 optimized path
Message-ID: <20120222162224.GA5256@elte.hu>
References: <20120221083621.11350.4716.stgit@localhost.localdomain>
 <tip-f5dbbb8e1e055d6f02817a1995993b461910b1b7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-f5dbbb8e1e055d6f02817a1995993b461910b1b7@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Commit-ID:  f5dbbb8e1e055d6f02817a1995993b461910b1b7
> Gitweb:     http://git.kernel.org/tip/f5dbbb8e1e055d6f02817a1995993b461910b1b7
> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> AuthorDate: Tue, 21 Feb 2012 17:36:21 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 22 Feb 2012 11:31:34 +0100
> 
> x86/kprobes: Fix to recover instructions on optimized path

Does not build on x86 if CONFIG_OPTPROBES is off:

arch/x86/kernel/kprobes.c:260:8: error: dereferencing pointer to incomplete type
arch/x86/kernel/kprobes.c:260:8: error: invalid use of undefined type ‘struct optimized_kprobe’
arch/x86/kernel/kprobes.c:262:22: error: dereferencing pointer to incomplete type
arch/x86/kernel/kprobes.c:264:18: error: dereferencing pointer to incomplete type

Thanks,

	Ingo
