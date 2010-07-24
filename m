Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0GXKvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:51:10 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39165 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab0GXKvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:51:07 -0400
Date: Sat, 24 Jul 2010 06:50:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: (short) list of non-existent "select" Kconfig variables
Message-ID: <alpine.DEB.2.00.1007240647380.10337@lynx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  since this is such a short list, i'll just post it -- the list of
Kconfig "select" directives that refer to undefined variables.
harmless, of course, but superfluous.  (didn't we have a discussion
about HAVE_READQ and HAVE_WRITEQ some time back?)


===== CRYPTO_SHASH
crypto/Kconfig:318:	select CRYPTO_SHASH
crypto/Kconfig:456:	select CRYPTO_SHASH
===== GCD
arch/arm/plat-pxa/include/plat/i2c.h:39:*  7.  GCD      1 (Disables i2c unit response to general call messages as a slave)
arch/mips/Kconfig:45:	select GCD
drivers/staging/cxt1e1/musycc.h:35: * musycc reg&bits namings. Use PORTMAP_0 GCD grouping.
drivers/i2c/busses/i2c-pxa.c:185:	PXA_BIT(ICR_GCD,    "GCD",	NULL),
fs/jffs2/background.c:98:		/* Problem - immediately after bootup, the GCD spends a lot
fs/jffs2/background.c:102:		 * doesn't help, either (presumably because userspace and GCD
fs/jffs2/background.c:105:		 * This forces the GCD to slow the hell down.   Pulling an
net/netfilter/ipvs/Kconfig:127:	select GCD
sound/core/Kconfig:8:	select GCD
===== GENERIC_HAS_IOMAP
arch/score/Kconfig:16:	select GENERIC_HAS_IOMAP
arch/score/Kconfig:22:	select GENERIC_HAS_IOMAP
arch/score/Kconfig:28:	select GENERIC_HAS_IOMAP
===== HAVE_READQ
arch/x86/Kconfig:22:	select HAVE_READQ
===== HAVE_WRITEQ
arch/x86/Kconfig:23:	select HAVE_WRITEQ
===== MACH_NEO1973
arch/arm/mach-s3c2440/Kconfig:101:	select MACH_NEO1973
===== MPC5121_ADS_CPLD
arch/powerpc/platforms/512x/Kconfig:18:	select MPC5121_ADS_CPLD
===== MSM_REMOTE_SPINLOCK_DEKKERS
arch/arm/mach-msm/Kconfig:20:	select MSM_REMOTE_SPINLOCK_DEKKERS
===== MSM_REMOTE_SPINLOCK_LDREX
arch/arm/mach-msm/Kconfig:28:	select MSM_REMOTE_SPINLOCK_LDREX
===== PPC_FSL_BOOK3E
arch/powerpc/platforms/85xx/Kconfig:151:	select PPC_FSL_BOOK3E
===== S3C2410_PWM
arch/arm/mach-s3c2440/Kconfig:102:	select S3C2410_PWM
arch/arm/mach-s3c2440/Kconfig:197:	select S3C2410_PWM
===== S3C_DEVICE_NAND
arch/arm/plat-s3c24xx/Kconfig:11:	select S3C_DEVICE_NAND
===== SFFSDR_FPGA
sound/soc/davinci/Kconfig:63:	select SFFSDR_FPGA
===== SIBYTE_CFE
arch/mips/sibyte/Kconfig:74:	select SIBYTE_CFE
===== SPI_MASTER_OF
drivers/spi/Kconfig:166:	select SPI_MASTER_OF
===== USB_GADGET_S3C_HSOTG_PIO
drivers/usb/gadget/Kconfig:297:	select USB_GADGET_S3C_HSOTG_PIO
===== XEN_XENBUS_FRONTEND
drivers/input/Kconfig:168:	select XEN_XENBUS_FRONTEND
drivers/video/Kconfig:2135:	select XEN_XENBUS_FRONTEND


rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
