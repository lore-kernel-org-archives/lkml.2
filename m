Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2JLJhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:37:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54681 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab2JLJhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:37:14 -0400
Date: Fri, 12 Oct 2012 10:37:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>, arnd@arndb.de,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>, dmurphy@ti.com
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121012093707.GC12567@gmail.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
 <20121011201735.GA15313@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121011201735.GA15313@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Nishanth Menon wrote:

> On 15:42-20121011, Lee Jones wrote:
> > From: Jonas Aaberg <jonas.aberg@stericsson.com>
> > 
> > The overhead is very low and the results will be found under
> > sysfs/bootime, as well as detailed results in debugfs under
> > boottime/. The bootgraph* files are compatible with
> > scripts/bootgraph.pl. The reason for this patch is to provide
> > data (sysfs/boottime) suitable for automatic testcases as
> > well as help for developers to reduce the boot time (debugfs).
> Tried master:
> 250d8 Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux
> and v3.6-rc7
> with omap2plus_defconfig + CONFIG_BOOTTIME enabled:
> 
> init/boottime.c:47:9: error: ‘cpu_usage_stat’ defined as wrong kind of tag
> init/boottime.c:47:24: error: array type has incomplete element type
> init/boottime.c: In function ‘boottime_mark_core’:
> init/boottime.c:127:313: error: ‘struct kernel_stat’ has no member named ‘cpustat’
> init/boottime.c:128:311: error: ‘struct kernel_stat’ has no member named ‘cpustat’
> init/boottime.c:129:313: error: ‘struct kernel_stat’ has no member named ‘cpustat’
> init/boottime.c:130:310: error: ‘struct kernel_stat’ has no member named ‘cpustat’
> 
> if it depended on some other patch or a specific maintainer branch,
> it was'nt clear.

No, this is completely my fault.

There are added dependencies and fixups that I missed.

I'll fixup and resubmit.

Unfortunately, there are now other authors involved, so I need to
seek permission before squashing them in. Please bear with me.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
