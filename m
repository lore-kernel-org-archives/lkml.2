Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2IKGZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:25:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35558 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2IKGZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:25:34 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v3 0/2] ARM: davinci: da850/omap-l138: add support for VPIF driver
Date: Tue, 11 Sep 2012 11:55:07 +0530
Message-ID: <1347344709-6180-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for VPIF
capture and display driver on da850/omap-l138.
Enables SD capture and display.

This patch series is dependent on the following patch:
https://patchwork.kernel.org/patch/1332311/

Changes for v3:
1: Clubbed the code for DA850_UI_SD_VIDEO_PORT config
   as pointed by Sekhar.
2: Define  the resource structure outside the function as pointed
   by Sekhar.

Changes for v2:
1: Avoid breaking of print messages.
2: Removed the handlers which just returned zero (which did nothing).
3: Clubbed the code where ever possible for DA850_UI_SD_VIDEO_PORT
   config option.
4: Removed the dma_declare_coherent_memory() calls and used
   global CMA.
5: Added the base address in increasing order.

Manjunath Hadli (2):
  ARM: da850/omap-l138: Add SoC related definitions for VPIF
  ARM: da850/omap-l138: Add EVM specific code for VPIF to work

Manjunath Hadli (2):
  ARM: da850/omap-l138: Add SoC related definitions for VPIF
  ARM: da850/omap-l138: Add EVM specific code for VPIF to work

 arch/arm/mach-davinci/Kconfig              |    7 ++
 arch/arm/mach-davinci/board-da850-evm.c    |  156 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/da850.c              |  152 +++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |   11 ++
 arch/arm/mach-davinci/include/mach/mux.h   |   42 ++++++++
 arch/arm/mach-davinci/include/mach/psc.h   |    1 +
 6 files changed, 369 insertions(+), 0 deletions(-)

