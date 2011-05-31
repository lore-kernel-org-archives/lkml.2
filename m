Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1EaMri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:47:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43098 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750830Ab1EaMrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:47:37 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+L8QMm4plZfgRcFyuH42qu
Date: Tue, 31 May 2011 05:47:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Syed Mohammed Khasim <x0khasim@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Steve Sakoman <steve@sakoman.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: OMAP2: Add missing include of linux/gpio.h
Message-ID: <20110531124733.GG11352@atomide.com>
References: <1306845769.27719.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306845769.27719.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Axel Lin <axel.lin@gmail.com> [110531 05:39]:
> I got some build error like below while executing "make omap2plus_defconfig".
> 
>   CC      arch/arm/mach-omap2/board-2430sdp.o
> arch/arm/mach-omap2/board-2430sdp.c: In function 'omap_2430sdp_init':
> arch/arm/mach-omap2/board-2430sdp.c:247: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
> arch/arm/mach-omap2/board-2430sdp.c:247: error: (Each undeclared identifier is reported only once
> arch/arm/mach-omap2/board-2430sdp.c:247: error: for each function it appears in.)
> make[1]: *** [arch/arm/mach-omap2/board-2430sdp.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2
> 
> This patch fixes the build error.

Can you please update this to also remove the wrong mach/gpio.h include?

Thanks,

Tony
