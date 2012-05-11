Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946238Ab2EKVey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:34:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42710 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957Ab2EKVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:34:52 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-doc@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] MIPS/spi: New driver for SPI master controller for OCTEON SOCs.
Date: Fri, 11 May 2012 14:34:44 -0700
Message-Id: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Several members of the OCTEON family have on-chips SPI master
controller hardware, so here is a driver for it.

I split the register definitions out to a separate patch so that they
live with all the other similar files for other OCTEON hardware blocks
in arch/mips/include/asm/octeon.  This does leave the question of who
should merge these.  I don't have a preference, could be Ralf's
Linux/MIPS tree or via the SPI maintainers.

Tested by driving an at25 eeprom.

David Daney (2):
  MIPS: OCTEON: Add register definitions for SPI host hardware.
  spi: Add SPI master controller for OCTEON SOCs.

 .../devicetree/bindings/spi/spi-octeon.txt         |   33 ++
 arch/mips/include/asm/octeon/cvmx-mpi-defs.h       |  328 +++++++++++++++++
 drivers/spi/Kconfig                                |    7 +
 drivers/spi/Makefile                               |    1 +
 drivers/spi/spi-octeon.c                           |  369 ++++++++++++++++++++
 5 files changed, 738 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-octeon.txt
 create mode 100644 arch/mips/include/asm/octeon/cvmx-mpi-defs.h
 create mode 100644 drivers/spi/spi-octeon.c

-- 
1.7.2.3

