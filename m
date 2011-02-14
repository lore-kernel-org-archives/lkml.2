Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1BNSp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:45:27 -0500
Received: from www.tglx.de ([62.245.132.106]:50350 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab1BNSpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:45:25 -0500
Date: Mon, 14 Feb 2011 19:43:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rabin Vincent <rabin@rab.in>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [patch 63/75] genirq: Add IRQCHIP_SET_TYPE_MASKED flag and
 IRQD_WAKE_SET
In-Reply-To: <AANLkTin8giwcc-odm29v5hu4fe-yH1Ub1wtJZ8sx93Vf@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1102141942390.26192@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <20110210223300.376194902@linutronix.de> <AANLkTin8giwcc-odm29v5hu4fe-yH1Ub1wtJZ8sx93Vf@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Rabin Vincent wrote:

> On Fri, Feb 11, 2011 at 05:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Add also a flag which reflects the WAKEUP state of the interrupt line,
> > which is also required by some of those chips.
> 
> This part (the IRQD_WAKE_SET mentioned in the subject) appears to be
> missing from this patch?

Yep, intentionally. Subject line is crapped. Fixed locally already.

Thanks for pointing it out.

       tglx

