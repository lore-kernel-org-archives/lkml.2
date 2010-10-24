Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab0JXSJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 14:09:14 -0400
Received: from www.tglx.de ([62.245.132.106]:51134 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab0JXSJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 14:09:13 -0400
Date: Sun, 24 Oct 2010 20:08:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kyle Moffett <kyle@moffetthome.net>
cc: Serafeim Zanikolas <sez@debian.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: jiffies.c: fix typos in comment
In-Reply-To: <AANLkTin2-h3+ts2JuZ4rxLSppr3Lqh1VCoi3sRQEHoaB@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010242006460.13092@localhost6.localdomain6>
References: <1287849986-5936-1-git-send-email-sez@debian.org> <alpine.LFD.2.00.1010241618480.8736@localhost6.localdomain6> <AANLkTin2-h3+ts2JuZ4rxLSppr3Lqh1VCoi3sRQEHoaB@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010, Kyle Moffett wrote:
> Thomas,
> 
> Please reread the patch again, I think it does exactly what he said it
> did.  Specifically, the old text is:
> >>   * the timer interrupt frequency HZ and it suffers
> >>   * inaccuracies caused by missed or lost timer
> >>   * interrupts and the inability for the timer
> >>   * interrupt hardware to accuratly tick at the
> >>   * requested HZ value. It is also not reccomended
> >>   * for "tick-less" systems.
> 
> While the new text is:
> >>   * the timer interrupt frequency HZ and it suffers
> >>   * inaccuracies caused by missed or lost timer
> >>   * interrupts and the inability for the timer
> >>   * interrupt hardware to accurately tick at the
> >>   * requested HZ value. It is also not recommended
> >>   * for "tick-less" systems.
> 
> I misread it the first time myself, mentally combining the second line
> of the old text with the new text; what you probably saw was:
> 
> >> - * requested HZ value. It is also not reccomended
> >> + * interrupt hardware to accurately tick at the
> >> + * requested HZ value.

Crap yes. I read it twice and still failed to parse it correctly.

Thanks,

	tglx
