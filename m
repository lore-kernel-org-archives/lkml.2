Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1BKLmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 06:42:50 -0500
Received: from www.tglx.de ([62.245.132.106]:48439 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab1BKLmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 06:42:49 -0500
Date: Fri, 11 Feb 2011 12:42:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ryan Mallon <ryan@bluewatersys.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [patch 34/75] arm: ep93xx: Kill another instance of broken
 irq_desc fiddling
In-Reply-To: <4D548146.5090507@bluewatersys.com>
Message-ID: <alpine.LFD.2.00.1102111240190.31804@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <20110210223257.597367298@linutronix.de> <4D548146.5090507@bluewatersys.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Ryan Mallon wrote:

> On 02/11/2011 12:37 PM, Thomas Gleixner wrote:
> > 1. This is a copy of the borked code in gpiolib
> > 2. If you need information about irq state which is not exposed, then talk
> >    to the maintainer of that code instead of adding totaly horrible open
> >    coded access.
> 
> This code got added simply because it is sometimes helpful to be able to
> see how various gpio/irq pins are configured. I'm happy to drop the
> functionality (see below), but is there a better way to get this
> information? Is it already available somewhere else (proc, sys)?

No, but we can add that if it's required in a sane form.

I don't have objections to expose debug informations in general, but
I have objections that random code does this especially, when it's
duplicated random code :)

Thanks,

	tglx
