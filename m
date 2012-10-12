Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab2JLNxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:53:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab2JLNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:53:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of kernel/bootloader boot time
Date: Fri, 12 Oct 2012 13:53:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dan Murphy <dmurphy@ti.com>, Nishanth Menon <nm@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org> <20121012134542.GH12567@gmail.com> <20121012134813.GK21164@n2100.arm.linux.org.uk>
In-Reply-To: <20121012134813.GK21164@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210121353.16798.arnd@arndb.de>
X-Provags-ID: V02:K0:k+JrQB3y2frIZfLSfmCRIB1ATiXR5gNk1Cwj++wjXJ4
 QpYINtG7bEx6zmJTXwjh1DIf+sFp9mxhxzonkoPQX6PpWGWcVs
 GI01VgGxKbluF59u0qSlUoZe8Hc+4ecCm3Pwi0WfYaNxNpWQkF
 YCkDHebBXtmeyJWaXs+Q6lB3jTM6XUFTIQVJWtYNi35+MIqokO
 Qc7F8GjE/EDr5QddToRv2dH/BOPRxs8Tar44CC5D0jkB8wcMWi
 YfSU1TtV+71tpwP9ziyflQBiz4+Wi/hpO5KOpKzBiyNHyDREFS
 iHVPgbCyVoEqnn4TO4WbscxCc67VOoaA0CngVyP+lqxw9t0uVl
 5J4/L5HU3iw1Q6MBDYDc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2012, Russell King - ARM Linux wrote:
> > root@ME:/ cat /sys/kernel/debug/boottime/bootgraph
> > [    0.185254] calling  splash+0x0/0x0
> > [    2.984335] initcall splash+0x0/0x0 returned 0 after 2799 msecs.
> > [    2.984335] calling  autoboot_delay+0x0/0x0
> > [    4.089513] initcall autoboot_delay+0x0/0x0 returned 0 after 1105 msecs.
> > [    4.089513] calling  load_kernel+0x0/0x0
> > [    4.239174] initcall load_kernel+0x0/0x0 returned 0 after 149 msecs.
> > [    4.239174] calling  boot_kernel+0x0/0x0
> > [    4.276260] initcall boot_kernel+0x0/0x0 returned 0 after 37 msecs.
> > [    4.276260] calling  uncompress_ll_init+0x0/0x0
> > [    4.276260] initcall uncompress_ll_init+0x0/0x0 returned 0 after 0 msecs.
> > [    4.276260] Freeing init memory: 0K
> 
> Umm, what happened to sysfs not becoming procfs v2?  I thought we had
> a fairly strict requirement for "one value per file and not nicely
> formatted" for sysfs?
> 

I was thinking the same thing at first, but then I noticed it's actually
debugfs, which has no such rules.

	Arnd
