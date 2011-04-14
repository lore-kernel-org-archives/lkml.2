Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab1DNTFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:05:25 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:34473 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab1DNTFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:05:23 -0400
Subject: Re: [PATCH 3/4] TPS65910: IRQ: Add interrupt controller
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
In-Reply-To: <alpine.LFD.2.00.1104141819230.2744@localhost6.localdomain6>
Date: Thu, 14 Apr 2011 14:05:18 -0500
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, sameo@linux.intel.com
Content-Transfer-Encoding: 8BIT
Message-Id: <C71658B6-2554-40D0-B8DA-8F1CB358E6FA@slimlogic.co.uk>
References: <A091F271-DC3C-468A-9175-93D2C4580F10@slimlogic.co.uk> <alpine.LFD.2.00.1104141819230.2744@localhost6.localdomain6>
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
On Apr 14, 2011, at 11:22 AM, Thomas Gleixner wrote:

> On Thu, 14 Apr 2011, Jorge Eduardo Candelaria wrote:
>> +static void tps65910_irq_lock(unsigned int irq)
>> +static void tps65910_irq_sync_unlock(unsigned int irq)
>> +static void tps65910_irq_enable(unsigned int irq)
>> +static void tps65910_irq_disable(unsigned int irq)
>> +
>> +static struct irq_chip tps65910_irq_chip = {
>> +	.name = "tps65910",
>> +	.irq_bus_lock = tps65910_irq_lock,
>> +	.irq_bus_sync_unlock = tps65910_irq_sync_unlock,
>> +	.irq_disable = tps65910_irq_disable,
>> +	.irq_enable = tps65910_irq_enable,
>> +};
> 
> Care to explain how that compiles?

I didn't notice it because there was no compilation error, however, I failed to
see the following warnings:

drivers/mfd/tps65910-irq.c:124: warning: initialization from incompatible pointer type
drivers/mfd/tps65910-irq.c:125: warning: initialization from incompatible pointer type
drivers/mfd/tps65910-irq.c:126: warning: initialization from incompatible pointer type
drivers/mfd/tps65910-irq.c:127: warning: initialization from incompatible pointer type

I'm changing this for v2.

Thanks,
Jorge

> 
> Thanks,
> 
> 	tglx

