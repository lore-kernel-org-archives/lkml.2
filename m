Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab0CaLTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 07:19:24 -0400
Received: from www.tglx.de ([62.245.132.106]:38059 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0CaLTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 07:19:20 -0400
Date: Wed, 31 Mar 2010 13:16:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [patch 1/2] genirq: Run irq handlers with interrupts disabled
In-Reply-To: <20100330053325.GL20695@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1003311315520.32352@localhost.localdomain>
References: <20100326000325.917127328@linutronix.de> <20100326000405.758579387@linutronix.de> <20100326061310.GV20695@one.firstfloor.org> <alpine.LFD.2.00.1003261224070.3147@localhost.localdomain> <20100330053325.GL20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Andi Kleen wrote:

> > Why not simply force IRQF_DISABLED for all MSI interrupts. That still
> > allows nesting for non MSI ones, but it limits the chance of throwing
> > up reasonably well. That's a two liner.
> > 
> > Can you please test whether it resolves the issue at hand ?
> 
> Sorry for the late answer. Got confirmation that this patch
> fixes the test case. Thanks.

Ok, I'll push it linus wards and cc stable. I think thats the least
intrusive safe bet we can have right now.

Thanks,

	tglx
