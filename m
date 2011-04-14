Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab1DNQWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:22:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:44905 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab1DNQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:22:24 -0400
Date: Thu, 14 Apr 2011 18:22:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, sameo@linux.intel.com
Subject: Re: [PATCH 3/4] TPS65910: IRQ: Add interrupt controller
In-Reply-To: <A091F271-DC3C-468A-9175-93D2C4580F10@slimlogic.co.uk>
Message-ID: <alpine.LFD.2.00.1104141819230.2744@localhost6.localdomain6>
References: <A091F271-DC3C-468A-9175-93D2C4580F10@slimlogic.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Jorge Eduardo Candelaria wrote:
> +static void tps65910_irq_lock(unsigned int irq)
> +static void tps65910_irq_sync_unlock(unsigned int irq)
> +static void tps65910_irq_enable(unsigned int irq)
> +static void tps65910_irq_disable(unsigned int irq)
> +
> +static struct irq_chip tps65910_irq_chip = {
> +	.name = "tps65910",
> +	.irq_bus_lock = tps65910_irq_lock,
> +	.irq_bus_sync_unlock = tps65910_irq_sync_unlock,
> +	.irq_disable = tps65910_irq_disable,
> +	.irq_enable = tps65910_irq_enable,
> +};

Care to explain how that compiles?

Thanks,

	tglx
