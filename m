Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab1FMJ34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:29:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab1FMJ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:29:55 -0400
Date: Mon, 13 Jun 2011 11:29:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
Message-ID: <20110613092940.GB8282@elte.hu>
References: <1307777464.25182.3.camel@localhost.localdomain>
 <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> > Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
> >
> >   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
> >   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function
> 
> What's the code path that uses ret without initializing it?

If the code is correct but GCC got confused then please use the 
simplest possible patch to help GCC find its way around the code.

Thanks,

	Ingo
