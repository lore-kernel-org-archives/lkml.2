Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1A0HzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:55:21 -0500
Received: from www.tglx.de ([62.245.132.106]:46304 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1A0HzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:55:19 -0500
Date: Thu, 27 Jan 2011 08:54:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-mips@linux-mips.org
Subject: Re: [patch 3/9] mips: Replace deprecated spinlock initialization
In-Reply-To: <20110124124215.GA3133@linux-mips.org>
Message-ID: <alpine.LFD.2.00.1101270854480.31804@localhost6.localdomain6>
References: <20110123143631.392446736@linutronix.de> <20110123143837.128260362@linutronix.de> <20110124124215.GA3133@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, Ralf Baechle wrote:

> Thanks, applied.
> 
>   Ralf
> 

I take it through core/locking in tip as well, because further
cleanups depend on it. Git will sort out the identical changes.

Thanks,

        tglx
