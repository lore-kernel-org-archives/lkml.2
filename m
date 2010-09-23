Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0IWSZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:25:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:34739 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab0IWSZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:25:41 -0400
From: Anders Wallin <Anders.Wallin@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com
Subject: [PATCH 0/1] Adding support for STA2x11/ConneXt PCIexpress function 0xCC0C.
Date: Thu, 23 Sep 2010 20:25:31 +0200
Message-Id: <cover.1285266234.git.anders.wallin@windriver.com>
X-Mailer: git-send-email 1.7.0.5
X-OriginalArrivalTime: 23 Sep 2010 18:25:37.0978 (UTC) FILETIME=[B869E1A0:01CB5B4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Wallin <anders.wallin@windriver.com>

This function enable access to multiple IP-blocks including 4 GPIO blocks,
one System Control block and one Timer block. Access to the PCIe device is managed by a MUX driver. 
The pl061_pci gpio driver is based on the ARM pl061 IP block, but the functionality is not a one to one map. The gpio driver needs the generic "gpio_to_irq" support.

Anders Wallin (1):
  Adding support for STA2x11/Connext PCIexpress function 0xCC0C.

 arch/x86/include/asm/gpio.h   |    2 +-
 drivers/gpio/Kconfig          |   14 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/pl061_pci.c      |  860 +++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/pl061_pci.h      |   29 ++
 drivers/misc/Kconfig          |   23 ++
 drivers/misc/Makefile         |    3 +
 drivers/misc/sta2x11_apbreg.c |  177 +++++++++
 drivers/misc/sta2x11_apbreg.h |   39 ++
 drivers/misc/sta2x11_mux.c    |  265 +++++++++++++
 drivers/misc/sta2x11_mux.h    |   50 +++
 drivers/misc/sta2x11_sctl.c   |  189 +++++++++
 drivers/misc/sta2x11_sctl.h   |  143 +++++++
 13 files changed, 1794 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpio/pl061_pci.c
 create mode 100644 drivers/gpio/pl061_pci.h
 create mode 100644 drivers/misc/sta2x11_apbreg.c
 create mode 100644 drivers/misc/sta2x11_apbreg.h
 create mode 100644 drivers/misc/sta2x11_mux.c
 create mode 100644 drivers/misc/sta2x11_mux.h
 create mode 100644 drivers/misc/sta2x11_sctl.c
 create mode 100644 drivers/misc/sta2x11_sctl.h

