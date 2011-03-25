Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1CYRyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:54:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:34278 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab1CYRyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:54:19 -0400
Date: Fri, 25 Mar 2011 18:54:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] tile: Final irq bits for .39
In-Reply-To: <4D8CD17C.9040104@tilera.com>
Message-ID: <alpine.LFD.2.00.1103251853400.31464@localhost6.localdomain6>
References: <20110325141938.846639464@linutronix.de> <4D8CD17C.9040104@tilera.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, Chris Metcalf wrote:

> On 3/25/2011 10:21 AM, Thomas Gleixner wrote:
> > Chris,
> >
> > the series converts the irq functions to the new function names and
> > makes use of the generic show_interrupts() implementation.
> >
> > Can you please ack or send it to Linus yourself ?
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> 
> I'd probably prefer you send it, but if you'd like me to, let me know.  I

I send it.

Thanks,

	tglx
