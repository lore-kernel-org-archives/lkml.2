Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2JPVMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:12:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:45774 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2JPVMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:12:23 -0400
Date: Tue, 16 Oct 2012 23:12:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Javier Sanz <jsanza@gmail.com>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.1-rt2
In-Reply-To: <CAOLSsAyV3XdJvNvFF_6d_oLnApyQVs4UoAJ0rPpABxkaGGxX1A@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210162311490.2811@ionos>
References: <alpine.LFD.2.02.1210162037380.2811@ionos> <CAP=VYLoHhtth2+BwQAsd7uyW8N+rJj6zznP9sNjczTj_0Uqk9w@mail.gmail.com> <CAOLSsAyV3XdJvNvFF_6d_oLnApyQVs4UoAJ0rPpABxkaGGxX1A@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Javier Sanz wrote:

> Hello,
> 
> Testing, and FYI
> 
> $uname -a
> Linux darkstar 3.6.1-rt2 #1 SMP PREEMPT RT Tue Oct 16 22:47:06 CEST 2012
> i686 i686 i386 GNU/Linux
> 
> >>shows all time  ...
> 
> [   30.543233] fuse init (API version 7.20)
> [   33.262077] Crap, ksoftirqd/0 looping forever in softirq
> [   33.344865] Crap, ksoftirqd/2 looping forever in softirq
> [   33.401736] Crap, ksoftirqd/0 looping forever in softirq
> [   33.409743] Crap, ksoftirqd/0 looping forever in softirq
> [   33.421658] Crap, ksoftirqd/0 looping forever in softirq
> [   33.428628] Crap, ksoftirqd/0 looping forever in softirq
> [   33.496468] Crap, ksoftirqd/2 looping forever in softirq

Grrr. Forgot to remove that printk. Will do in the next spin.

