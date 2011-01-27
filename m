Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1A0Hyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:54:32 -0500
Received: from www.tglx.de ([62.245.132.106]:46265 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1A0Hyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:54:31 -0500
Date: Thu, 27 Jan 2011 08:54:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Turner <mattst88@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: Re: [patch 1/9] alpha: Replace deprecated spinlock initialization
In-Reply-To: <AANLkTin1ct3NfBP8kiaEweA6ZEPTvKfCqgN-nVdJ0n0g@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101270851370.31804@localhost6.localdomain6>
References: <20110123143631.392446736@linutronix.de> <20110123143836.940494132@linutronix.de> <AANLkTin1ct3NfBP8kiaEweA6ZEPTvKfCqgN-nVdJ0n0g@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011, Matt Turner wrote:
> On Sun, Jan 23, 2011 at 3:16 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> Thanks! I'll apply this.

I take it through core/locking in tip as well, because further
cleanups depend on it. Git will sort out the identical changes.

Thanks,

	tglx
