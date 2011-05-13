Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab1EMPRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:17:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:38520 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab1EMPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:17:11 -0400
Date: Fri, 13 May 2011 17:17:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: export handle_simple_irq, irq_modify_status,
 irq_to_desc, irq_alloc_descs and irq_free_descs
In-Reply-To: <4DCD3696.3090804@cam.ac.uk>
Message-ID: <alpine.LFD.2.02.1105131712520.2799@ionos>
References: <1304525890-11915-1-git-send-email-jic23@cam.ac.uk> <4DCA5A97.90704@cam.ac.uk> <4DCD3696.3090804@cam.ac.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Jonathan Cameron wrote:

> Hi Thomas.
> 
> Just a quick request that you give a yes or no to this.
> 
> Thanks and sorry for repeated pestering!

Sorry for the delay.
 
> >>  /**
> >>   *	irq_cpu_online - Invoke all irq_cpu_online functions.
> >> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> >> index 2c039c9..5ac14e2 100644
> >> --- a/kernel/irq/irqdesc.c
> >> +++ b/kernel/irq/irqdesc.c
> >> @@ -110,6 +110,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
> >>  {
> >>  	return radix_tree_lookup(&irq_desc_tree, irq);
> >>  }
> >> +EXPORT_SYMBOL_GPL(irq_to_desc);

I'm fine with that, just this one makes me a bit wary. I have a closer
look over the weekend.

Thanks,

	tglx
