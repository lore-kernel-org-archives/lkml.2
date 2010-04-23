Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0DWPMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:12:40 -0400
Received: from smtp.nokia.com ([192.100.122.233]:20049 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab0DWPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:12:35 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCH 0/5] HSI framework and drivers
Date: Fri, 23 Apr 2010 18:15:23 +0300
Message-Id: <1272035728-6933-1-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 23 Apr 2010 15:12:25.0710 (UTC) FILETIME=[61AE68E0:01CAE2F7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I have been working on a new proposal to support HSI/SSI drivers
in the kernel. I would be very glad to get your feedback about
this proposal.

This patch series introduces the HSI framework, an SSI driver
for OMAP and a generic character device for HSI/SSI devices.

SSI, which is a legacy version of HSI, is used to connect the application
engine with the cellular modem on the Nokia N900.

This patch set is based on 2.6.34-rc3

Br,
Carlos Chinea

Andras Domokos (2):
  HSI CHAR: Add HSI char device driver
  HSI CHAR: Add HSI char device kernel configuration

Carlos Chinea (3):
  HSI: Introducing HSI framework
  OMAP SSI: Introducing OMAP SSI driver
  OMAP SSI: Add OMAP SSI to the kernel configuration

 arch/arm/mach-omap2/Makefile          |    3 +
 arch/arm/mach-omap2/ssi.c             |  139 +++
 arch/arm/plat-omap/include/plat/ssi.h |  196 ++++
 drivers/Kconfig                       |    2 +
 drivers/Makefile                      |    1 +
 drivers/hsi/Kconfig                   |   16 +
 drivers/hsi/Makefile                  |    5 +
 drivers/hsi/clients/Kconfig           |   11 +
 drivers/hsi/clients/Makefile          |    5 +
 drivers/hsi/clients/hsi_char.c        | 1078 +++++++++++++++++++++
 drivers/hsi/controllers/Kconfig       |   11 +
 drivers/hsi/controllers/Makefile      |    5 +
 drivers/hsi/controllers/omap_ssi.c    | 1691 +++++++++++++++++++++++++++++++++
 drivers/hsi/hsi.c                     |  487 ++++++++++
 include/linux/hsi/hsi.h               |  365 +++++++
 include/linux/hsi/hsi_char.h          |   79 ++
 16 files changed, 4094 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/ssi.c
 create mode 100644 arch/arm/plat-omap/include/plat/ssi.h
 create mode 100644 drivers/hsi/Kconfig
 create mode 100644 drivers/hsi/Makefile
 create mode 100644 drivers/hsi/clients/Kconfig
 create mode 100644 drivers/hsi/clients/Makefile
 create mode 100644 drivers/hsi/clients/hsi_char.c
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/hsi.c
 create mode 100644 include/linux/hsi/hsi.h
 create mode 100644 include/linux/hsi/hsi_char.h

