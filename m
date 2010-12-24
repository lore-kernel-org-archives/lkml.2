Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0LXDVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 22:21:52 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45325 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab0LXDVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 22:21:51 -0500
Date: Fri, 24 Dec 2010 12:20:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.37-rc7
Message-ID: <20101224032014.GH28151@linux-sh.org>
References: <alpine.DEB.2.00.1012232128380.6624@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012232128380.6624@ayla.of.borg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 09:28:52PM +0100, Geert Uytterhoeven wrote:
> 54 regressions:
> 	error: "vmalloc_node" [net/core/pktgen.ko] undefined!:  => N/A
> 	error: "vmalloc_node" [net/netfilter/x_tables.ko] undefined!:  => N/A

Ah, this is a nommu regression. Fixed, will send to Linus shortly.

> 	src/arch/sh/boards/mach-se/7206/irq.c: error: 'INTC_ICR' undeclared (first use in this function):  => 143
> 	src/arch/sh/boards/mach-se/7206/irq.c: error: (Each undeclared identifier is reported only once:  => 143
> 	src/arch/sh/boards/mach-se/7206/irq.c: error: for each function it appears in.):  => 143
> 	src/arch/sh/kernel/cpu/sh4/clock-sh4-202.c: error: too many arguments to function 'clk->ops->set_rate':  => 85

Fixed.

> 165 regressions:
> 	src/arch/sh/kernel/cpu/sh2a/clock-sh7201.c: warning: 'return' with a value, in function returning void:  => 37

This is actually a serious bug, so that's fixed too.

Thanks for the report, this is quite useful!
