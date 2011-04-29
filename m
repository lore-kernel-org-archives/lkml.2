Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758Ab1D2RoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:44:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47707 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760742Ab1D2RoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:44:06 -0400
Date: Fri, 29 Apr 2011 11:43:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/6] General device tree irq domain infrastructure
Message-ID: <20110429174355.GA21098@ponder.secretlab.ca>
References: <20110428192227.8979.49181.stgit@ponder>
 <4DBAE461.7000307@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBAE461.7000307@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 06:16:33PM +0200, Sebastian Andrzej Siewior wrote:
> Grant Likely wrote:
> >I'd really like to get patches 1-4 merged into 2.6.40.  Please test.
> >I'm also running through build testing here, and when it's complete
> >I'll push it out to a 'devicetree/irq-domain' branch on
> >git://git.secretlab.ca/git/linux-2.6
> 
> I pulled this, built and booted my x86-dt box and nothing exploded so far.
> 
> If you merge Linus' tree then you will get a conflict (sooner or later) in
> ioapic_of_irq_map() in arch/x86/kernel/devicetree.c:
> 
> -       return io_apic_setup_irq_pin_once(*out_hwirq, cpu_to_node(0), &attr);
>  -      if (io_apic_setup_irq_pin(hwirq, cpu_to_node(0), &attr))
> ++      if (io_apic_setup_irq_pin_once(hwirq, cpu_to_node(0), &attr))
> 
> Sebastian

Thanks Sebastian.  Unless you say otherwise, I'll take that as an Acked-by.  :-)

g.
