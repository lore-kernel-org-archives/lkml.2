Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3ACEyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 23:54:03 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:56445 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3ACEyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 23:54:00 -0500
Message-ID: <1357188837.9052.5.camel@gitbox>
Subject: Re: [PATCH 2/2] irqchip: vt8500: Move irq code to drivers/irqchip
From: Tony Prisk <linux@prisktech.co.nz>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 03 Jan 2013 17:53:57 +1300
In-Reply-To: <50E50B45.4040501@gmail.com>
References: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz>
	 <1357183510-8476-3-git-send-email-linux@prisktech.co.nz>
	 <50E50B45.4040501@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 22:38 -0600, Rob Herring wrote:
> > CC: Thomas Gleixner <tglx@linutronix.de>
> >  arch/arm/mach-vt8500/Makefile |    2 +-
> >  arch/arm/mach-vt8500/common.h |    7 +-
> >  arch/arm/mach-vt8500/irq.c    |  253 -----------------------------------------
> >  drivers/irqchip/Makefile      |    1 +
> >  drivers/irqchip/irq-vt8500.c  |  253 +++++++++++++++++++++++++++++++++++++++++
> 
> It's easy to forget, but please post using the -M option so only real
> changes are shown.

Ok.

> > -/* defined in irq.c */
> > +/* defined in drivers/irqchip/irq.c */
> > +int __init vt8500_irq_init(struct device_node *node,
> > +				struct device_node *parent);
> >  asmlinkage void vt8500_handle_irq(struct pt_regs *regs);
> 
> These should go away with irqchip infrastructure Thomas and I have been
> working on. I plan to post updated version in the next day.
> 
> Rob

Do you want me to rebase this patch on the new infrastructure once it's
in a tree somewhere, or was this a heads-up that it will need another
patch at some point?

I only ask because if these patches need to be separated it will created
merge-conflicts with arm-soc later on.

Regards
Tony P

