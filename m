Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2EKHNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:13:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38674 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2EKHNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:13:13 -0400
Date: Fri, 11 May 2012 16:13:08 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        arnd@arndb.de, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, lethal@linux-sh.org, olof@lixom.net
Subject: Re: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
Message-ID: <20120511071305.GD17741@verge.net.au>
References: <20120509075407.5991.60556.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509075407.5991.60556.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 04:54:07PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Prototype code that adds SMP support to EMEV2.
> 
> At this point only the most basic form of SMP operation
> is supported. TWD and CPU Hotplug support is excluded.
> 
> Based on V1 of the Emma Mobile EV2 code. Needs to be
> reworked to coexist with DT. Work in progress.

Hi Magnus,

I tried out this patch on top of the next branch of Rafael's
renesas tree (5658c94) plus V2 of your Emma Mobile EV2 code but
I am only seeing one CPU.  Do I need some other tweaks?

The list of patches I have applied is as follows:

mach-shmobile: Emma Mobile EV2 SMP prototype code
ARM: mach-types: Manually add KZM-A9-GT
mach-shmobile: KZM9D board prototype support
mach-shmobile: Emma Mobile EV2 SoC base support
serial8250-em: Add DT support
serial8250-em: clk_get() IS_ERR() error handling fix
serial8250-em: Emma Mobile UART driver V2
serial8250: Introduce serial8250_register_8250_port()
serial8250: Clean up default map and dl code
serial8250: Use dl_read()/dl_write() on RM9K
serial8250: Use dl_read()/dl_write() on Alchemy
serial8250: Add dl_read()/dl_write() callbacks
8250.c: less than 2400 baud fix.
serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI
tegra, serial8250: add ->handle_break() uart_port op
clocksource: em_sti: Add DT support
clocksource: em_sti: Emma Mobile STI driver V2
clockevents: Make clockevents_config() a global symbol


And yes, I did enable CONFIG_SMP :)

