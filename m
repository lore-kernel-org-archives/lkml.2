Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1INJiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:38:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:40782 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1INJiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:38:12 -0400
Date: Wed, 14 Sep 2011 11:37:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shan Hai <haishan.bai@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
In-Reply-To: <20110914163455.fcc47a7aba8604c690988473@canb.auug.org.au>
Message-ID: <alpine.LFD.2.02.1109141137260.2723@ionos>
References: <20110914163455.fcc47a7aba8604c690988473@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the tip tree, today's linux-next build (powerpc allnoconfig)
> produced this warning:
> 
> lib/atomic64.c: In function 'lock_addr':
> lib/atomic64.c:42:2: warning: return from incompatible pointer type
> 
> Introduced by commit f59ca05871a0 ("locking, lib/atomic64: Annotate
> atomic64_lock::lock as raw").  This function (which is declared to return
> "spinlock_t *") is now returning "raw_spinlock_t *".

My bad, it seems I picked the wrong version of the patch.
