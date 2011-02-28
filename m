Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1B1S05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:26:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1B1S04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:26:56 -0500
Date: Mon, 28 Feb 2011 19:26:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, heukelum@fastmail.fm, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86-64: Add CFI annotations to lib/rwsem_64.S
Message-ID: <20110228182642.GA7041@elte.hu>
References: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
 <tip-39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c@git.kernel.org>
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


* tip-bot for Jan Beulich <JBeulich@novell.com> wrote:

> Commit-ID:  39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c
> Gitweb:     http://git.kernel.org/tip/39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c
> Author:     Jan Beulich <JBeulich@novell.com>
> AuthorDate: Mon, 28 Feb 2011 15:31:59 +0000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 28 Feb 2011 18:06:21 +0100
> 
> x86-64: Add CFI annotations to lib/rwsem_64.S
> 
> These weren't part of the initial commit of this code.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
> LKML-Reference: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/lib/rwsem_64.S |   56 ++++++++++++++++++++++++++++------------------
>  1 files changed, 34 insertions(+), 22 deletions(-)

this change breaks the UML build:

 tip/arch/um/sys-x86_64/../../x86/lib/rwsem_64.S:46: Error: no such instruction: `pushq_cfi %rdi'

Thanks,

	Ingo
