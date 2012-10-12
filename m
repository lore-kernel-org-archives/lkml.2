Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2JLOBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 10:01:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44594 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab2JLOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 10:01:54 -0400
Date: Fri, 12 Oct 2012 15:01:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Murphy <dmurphy@ti.com>, Nishanth Menon <nm@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121012140149.GJ12567@gmail.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
 <20121012134542.GH12567@gmail.com>
 <20121012134813.GK21164@n2100.arm.linux.org.uk>
 <201210121353.16798.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201210121353.16798.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Arnd Bergmann wrote:

> On Friday 12 October 2012, Russell King - ARM Linux wrote:
> > > root@ME:/ cat /sys/kernel/debug/boottime/bootgraph
> > > [    0.185254] calling  splash+0x0/0x0
> > > [    2.984335] initcall splash+0x0/0x0 returned 0 after 2799 msecs.
> > > [    2.984335] calling  autoboot_delay+0x0/0x0
> > > [    4.089513] initcall autoboot_delay+0x0/0x0 returned 0 after 1105 msecs.
> > > [    4.089513] calling  load_kernel+0x0/0x0
> > > [    4.239174] initcall load_kernel+0x0/0x0 returned 0 after 149 msecs.
> > > [    4.239174] calling  boot_kernel+0x0/0x0
> > > [    4.276260] initcall boot_kernel+0x0/0x0 returned 0 after 37 msecs.
> > > [    4.276260] calling  uncompress_ll_init+0x0/0x0
> > > [    4.276260] initcall uncompress_ll_init+0x0/0x0 returned 0 after 0 msecs.
> > > [    4.276260] Freeing init memory: 0K
> > 
> > Umm, what happened to sysfs not becoming procfs v2?  I thought we had
> > a fairly strict requirement for "one value per file and not nicely
> > formatted" for sysfs?
> > 
> 
> I was thinking the same thing at first, but then I noticed it's actually
> debugfs, which has no such rules.

Right. :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
