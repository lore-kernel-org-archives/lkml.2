Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab0CYL4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:56:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50123 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772Ab0CYL4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:56:33 -0400
Date: Thu, 25 Mar 2010 11:59:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
Message-ID: <20100325115934.425e15f0@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003251211350.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box>
	<alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
	<alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
	<20100325003652.GG20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
	<20100325105033.35bceffd@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003251211350.3147@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> time. What's the point of running it with interrupts enabled ?

The underlying question you posed was why don't we kill off the running
with irqs enabled cases. That requires more work but should definitely
happen.

> Nothing, we just run into stack overflow problems. So what's better:
> an unreliable and ugly hackaround or just avoiding the possible stack
> overflow in the first place ?

I think you are trying to have a debate when we are in agreement anyway.
I don't btw think the workaround is 'unreliable', ugly as sin yes but the
logic appears sound.

Alan
