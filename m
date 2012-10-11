Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab2JKURy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:17:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33202 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759226Ab2JKURw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:17:52 -0400
Date: Thu, 11 Oct 2012 15:17:35 -0500
From: Nishanth Menon <nm@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>, <arnd@arndb.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        <dmurphy@ti.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121011201735.GA15313@kahuna>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:42-20121011, Lee Jones wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> The overhead is very low and the results will be found under
> sysfs/bootime, as well as detailed results in debugfs under
> boottime/. The bootgraph* files are compatible with
> scripts/bootgraph.pl. The reason for this patch is to provide
> data (sysfs/boottime) suitable for automatic testcases as
> well as help for developers to reduce the boot time (debugfs).
Tried master:
250d8 Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux
and v3.6-rc7
with omap2plus_defconfig + CONFIG_BOOTTIME enabled:

init/boottime.c:47:9: error: ‘cpu_usage_stat’ defined as wrong kind of tag
init/boottime.c:47:24: error: array type has incomplete element type
init/boottime.c: In function ‘boottime_mark_core’:
init/boottime.c:127:313: error: ‘struct kernel_stat’ has no member named ‘cpustat’
init/boottime.c:128:311: error: ‘struct kernel_stat’ has no member named ‘cpustat’
init/boottime.c:129:313: error: ‘struct kernel_stat’ has no member named ‘cpustat’
init/boottime.c:130:310: error: ‘struct kernel_stat’ has no member named ‘cpustat’

if it depended on some other patch or a specific maintainer branch,
it was'nt clear.
-- 
Regards,
Nishanth Menon
