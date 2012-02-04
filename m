Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2BDVzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 16:55:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36379 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab2BDVzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 16:55:24 -0500
Date: Sat, 04 Feb 2012 16:51:22 -0500 (EST)
Message-Id: <20120204.165122.841855829159259361.davem@davemloft.net>
To: mbarekfiras@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: net: bpf_jit_comp: Fixed coding style issues.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328229495-7603-1-git-send-email-mbarekfiras@gmail.com>
References: <1328229495-7603-1-git-send-email-mbarekfiras@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 04 Feb 2012 13:51:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mbarek Firas <mbarekfiras@gmail.com>
Date: Fri,  3 Feb 2012 01:38:15 +0100

> -			COND_SEL(BPF_S_JMP_JGT_K, X86_JA, X86_JBE);
> -			COND_SEL(BPF_S_JMP_JGE_K, X86_JAE, X86_JB);
> -			COND_SEL(BPF_S_JMP_JEQ_K, X86_JE, X86_JNE);
> -			COND_SEL(BPF_S_JMP_JSET_K,X86_JNE, X86_JE);
> -			COND_SEL(BPF_S_JMP_JGT_X, X86_JA, X86_JBE);
> -			COND_SEL(BPF_S_JMP_JGE_X, X86_JAE, X86_JB);
> -			COND_SEL(BPF_S_JMP_JEQ_X, X86_JE, X86_JNE);
> -			COND_SEL(BPF_S_JMP_JSET_X,X86_JNE, X86_JE);
> +			COND_SEL(BPF_S_JMP_JGT_K,  X86_JA,  X86_JBE);
> +			COND_SEL(BPF_S_JMP_JGE_K,  X86_JAE, X86_JB);
> +			COND_SEL(BPF_S_JMP_JEQ_K,  X86_JE,  X86_JNE);
> +			COND_SEL(BPF_S_JMP_JSET_K, X86_JNE, X86_JE);

This is rediculious, it's not fixing anything.

There is no requirement that all the arguments have to line up
to the same column on every line.

I'm not applying this patch.
