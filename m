Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0CVISP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:18:15 -0400
Received: from www.tglx.de ([62.245.132.106]:33349 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab0CVISJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:18:09 -0400
Date: Mon, 22 Mar 2010 09:17:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <maz@misterjones.org>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       joachim.eastwood@jotron.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] genirq: introduce IRQF_ALLOW_NESTED flag for
 request_irq()
In-Reply-To: <20100322060343.3487e32c@taxman.wild-wind.fr.eu.org>
Message-ID: <alpine.LFD.2.00.1003220916120.3147@localhost.localdomain>
References: <201003112209.o2BM91oQ013581@imap1.linux-foundation.org> <alpine.LFD.2.00.1003132039110.22855@localhost.localdomain> <927ea285bd0c68934ddae1a47e44a9ba@localhost> <20100322060343.3487e32c@taxman.wild-wind.fr.eu.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010, Marc Zyngier wrote:
> > Please note that this patch has only been compile-tested, as I'm traveling
> > for the rest of the week and don't have access to my boards.
> > 
> > Thanks,
> > 
> >         M.
> 
> Any comment on this?

Yes, I was traveling last week and this is in my mail backlog :)

Thanks,

	tglx
