Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1AaKr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:47:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:49103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1AaKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:47:28 -0500
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused
 by pm_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTinxHXqndfP79W0=zer70psi6Dmkcv7rZc4ew7ZF@mail.gmail.com>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	 <1295894492.28776.470.camel@laptop>
	 <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	 <1295946736.28776.479.camel@laptop>
	 <AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
	 <1296210619.15234.263.camel@laptop>
	 <AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
	 <1296405366.2274.60.camel@twins>
	 <AANLkTinxHXqndfP79W0=zer70psi6Dmkcv7rZc4ew7ZF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 11:48:25 +0100
Message-ID: <1296470905.15234.363.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-30 at 22:26 -0500, Luming Yu wrote:
> 
> Booting Node 3 Processor 59 APIC 0x75
> Clocksource tsc unstable (delta = -77316000544 ns)
> Switching to clocksource hpet 

I think that's known NHM-EX suckage, it does all kinds of stupid things
in deeper C states that other NHM/WSM chips don't do.

