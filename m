Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2HARu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:50:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53453 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2HARu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:50:26 -0400
From: Matt Sealey <matt@genesi-usa.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Sealey <matt@genesi-usa.com>
Subject: [PATCH 0/4] Remove Genesi Efika MX support
Date: Wed,  1 Aug 2012 12:49:27 -0500
Message-Id: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to start afresh we are removing the "legacy" Efika MX support
from the tree in this patch series so as to break ties with any non-device-tree
code and minimize the possibility that there are two ways to build for our
boards.

Patches to support the board again with FDT (along with a matching U-Boot)
are not ready for submission, but that doesn't block *this* submission. The
number of users of 3.5 kernels on Genesi platforms is generally thought of
as zero and no significant work or support has been committed to the platform
in a long time. In our opinion, all efforts by external developers wishing to
run modern kernels on Genesi Efika MX boards should be directed at device tree
support for the MX51 platforms.

Matt Sealey (4):
  efikamx: remove support for Genesi Efika MX from the build
  efikamx: remove Genesi Efika MX from the i.MX v6/v7 defconfig
  efikamx: remove Genesi Efika MX platform files from the tree
  efikamx: remove Efika MX-specific CHRGVBUS hack from the USB driver

 arch/arm/configs/imx_v6_v7_defconfig  |    2 -
 arch/arm/mach-imx/Kconfig             |   26 --
 arch/arm/mach-imx/Makefile            |    3 -
 arch/arm/mach-imx/efika.h             |   10 -
 arch/arm/mach-imx/mach-mx51_efikamx.c |  300 ----------------
 arch/arm/mach-imx/mach-mx51_efikasb.c |  296 ---------------
 arch/arm/mach-imx/mx51_efika.c        |  632 ---------------------------------
 drivers/usb/host/ehci-mxc.c           |   20 --
 8 files changed, 1289 deletions(-)
 delete mode 100644 arch/arm/mach-imx/efika.h
 delete mode 100644 arch/arm/mach-imx/mach-mx51_efikamx.c
 delete mode 100644 arch/arm/mach-imx/mach-mx51_efikasb.c
 delete mode 100644 arch/arm/mach-imx/mx51_efika.c

-- 
1.7.9.5

