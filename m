Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1C3MIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:08:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:36204 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1C3MIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:08:22 -0400
Date: Wed, 30 Mar 2011 14:08:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] microblaze: Fix level/edge irq sensibility
In-Reply-To: <4D931C98.4010009@monstr.eu>
Message-ID: <alpine.LFD.2.00.1103301407480.22418@localhost6.localdomain6>
References: <1301484264-6220-1-git-send-email-monstr@monstr.eu> <alpine.LFD.2.00.1103301403290.22418@localhost6.localdomain6> <4D931C98.4010009@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Michal Simek wrote:

> Thomas Gleixner wrote:
> > On Wed, 30 Mar 2011, Michal Simek wrote:
> > 
> > > Patches:
> > > "microblaze: Convert to new irq function names"
> > > sha (4adc192ec7d977c74c750320f289af9d61c1caca)
> > > and
> > > "microblaze: Use generic show_interrupts()"
> > > sha(9d61c18b25726306c9231428c17db42e3ff29ba7)
> > > 
> > > should also setup edge/level in irq_set_chip_and_handler_name
> > > name parameter.
> > > 
> > > Error log:
> > > ~ # cat /proc/interrupts
> > >            CPU0
> > >   2:          2  Xilinx INTC-Xilinx INTC  eth0
> > >   3:          2  Xilinx INTC-Xilinx INTC  eth0
> > >   4:        241  Xilinx INTC-Xilinx INTC  timer
> > >   6:        108  Xilinx INTC-Xilinx INTC  serial
> > > 
> > > Fixed:
> > > ~ # cat /proc/interrupts
> > >            CPU0
> > >   2:          2  Xilinx INTC-level     eth0
> > >   3:          2  Xilinx INTC-level     eth0
> > >   4:        238  Xilinx INTC-edge      timer
> > >   6:        108  Xilinx INTC-level     serial
> > > 
> > > Signed-off-by: Michal Simek <monstr@monstr.eu>
> > 
> > Should I pick that up for the urgent fixes ?
> 
> No you shouldn't. It can go through my tree.
> You can give me ACK if you like.

Here you go:

Acked-by: Thomas Gleixner <tglx@linutronix.de>
