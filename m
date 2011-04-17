Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1DQVtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:49:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16869 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1DQVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:49:32 -0400
Date: Mon, 18 Apr 2011 06:49:23 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 8/14] ARM / Samsung: Use struct syscore_ops for "core"
 power	management
In-reply-to: <201104172311.17082.rjw@sisk.pl>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Kevin Hilman'" <khilman@ti.com>, "'Guan Xuetao'" <gxt@mprc.pku.edu.cn>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Greg KH'" <gregkh@suse.de>, "'Ralf Baechle'" <ralf@linux-mips.org>,
        "'Jeremy Fitzhardinge'" <jeremy.fitzhardinge@citrix.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>, "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Kay Sievers'" <kay.sievers@suse.de>,
        "'Mike Frysinger'" <vapier@gentoo.org>,
        "'Linux PM mailing list'" <linux-pm@lists.linux-foundation.org>,
        linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "'Hans-Christian Egtvedt'" <hans-christian.egtvedt@atmel.com>,
        linux-arm-kernel@lists.infradead.org
Message-id: <008801cbfd49$5508c870$ff1a5950$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acv9RRb2c5wauT/6QYOi/fiv44Qn2wABAi7w
References: <201103280125.11750.rjw@sisk.pl> <201104172301.54115.rjw@sisk.pl>
 <201104172311.17082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Replace sysdev classes and struct sys_device objects used for "core"
> power management by Samsung platforms with struct syscore_ops objects
> that are simpler.
> 
> This generally reduces the code size and the kernel memory footprint.
> It also is necessary for removing sysdevs entirely from the kernel in
> the future.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

> ---
>  arch/arm/mach-exynos4/pm.c               |   45 ++++++++++++--------
>  arch/arm/mach-s3c2410/irq.c              |   30 -------------
>  arch/arm/mach-s3c2410/mach-bast.c        |   17 ++-----
>  arch/arm/mach-s3c2410/pm.c               |   13 ++---
>  arch/arm/mach-s3c2410/s3c2410.c          |    5 ++
>  arch/arm/mach-s3c2412/irq.c              |    2
>  arch/arm/mach-s3c2412/mach-jive.c        |   19 ++------
>  arch/arm/mach-s3c2412/pm.c               |   27 ++++++------
>  arch/arm/mach-s3c2412/s3c2412.c          |    4 +
>  arch/arm/mach-s3c2416/irq.c              |    2
>  arch/arm/mach-s3c2416/pm.c               |   27 +++++-------
>  arch/arm/mach-s3c2416/s3c2416.c          |    5 ++
>  arch/arm/mach-s3c2440/mach-osiris.c      |   18 ++------
>  arch/arm/mach-s3c2440/s3c2440.c          |    8 +++
>  arch/arm/mach-s3c2440/s3c2442.c          |    6 ++
>  arch/arm/mach-s3c2440/s3c244x-irq.c      |    4 -
>  arch/arm/mach-s3c2440/s3c244x.c          |   62
++++++++++++++--------------
>  arch/arm/mach-s3c64xx/irq-pm.c           |   18 ++++----
>  arch/arm/mach-s5pv210/pm.c               |   25 +++++++----
>  arch/arm/plat-s3c24xx/dma.c              |   68
+++++++++++-----------------
> ---
>  arch/arm/plat-s3c24xx/irq-pm.c           |    7 ---
>  arch/arm/plat-s5p/irq-pm.c               |    7 ---
>  arch/arm/plat-samsung/include/plat/cpu.h |    6 ++
>  arch/arm/plat-samsung/include/plat/pm.h  |    6 +-
>  24 files changed, 203 insertions(+), 228 deletions(-)
> 

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

