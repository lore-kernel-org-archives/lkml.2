Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab1ANIpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:45:47 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:56866 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1ANIpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:45:39 -0500
Date: Fri, 14 Jan 2011 09:45:38 +0100
From: Lennert Buytenhek <buytenh@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>
Subject: Re: linux-next: build warning in Linus' tree
Message-ID: <20110114084538.GW15575@mail.wantstofly.org>
References: <20110114105123.b05b4dcc.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114105123.b05b4dcc.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 10:51:23AM +1100, Stephen Rothwell wrote:

> While building Linus' tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> drivers/gpio/timbgpio.c: In function 'timbgpio_irq':
> drivers/gpio/timbgpio.c:202: warning: passing argument 1 of 'irq_get_irq_data' makes integer from pointer without a cast
> include/linux/irq.h:345: note: expected 'unsigned int' but argument is of type 'struct irq_data *'
> drivers/gpio/timbgpio.c:202: warning: passing argument 1 of 'desc-><U be0>.irq_data.chip->ack' makes integer from pointer without a cast
> drivers/gpio/timbgpio.c:202: note: expected 'unsigned int' but argument is of type 'struct irq_data *'
> drivers/gpio/timbgpio.c: In function 'timbgpio_probe':
> drivers/gpio/timbgpio.c:303: warning: passing argument 2 of 'set_irq_chained_handler' from incompatible pointer type
> include/linux/irq.h:294: note: expected 'irq_flow_handler_t' but argument is of type 'void (*)(struct irq_data *, struct irq_desc *)'
> 
> Introduced by commit a1f5f22adc3206c47e70652c12671666c65b579f ("gpio:
> timbgpio: irq_data conversion").

My bad.  Sorry about that.  Have just sent a fixup patch.
