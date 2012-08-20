Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2HTOJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:09:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35093 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2HTOJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:09:17 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v2 0/2] ARM: davinci: da850/omap-l138: add support for VPIF driver
Date: Mon, 20 Aug 2012 19:38:49 +0530
Message-ID: <1345471731-31678-1-git-send-email-prabhakar.lad@ti.com>
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

 arch/arm/mach-davinci/Kconfig              |    9 ++
 arch/arm/mach-davinci/board-da850-evm.c    |  178 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/da850.c              |  162 +++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |   11 ++
 arch/arm/mach-davinci/include/mach/mux.h   |   42 +++++++
 arch/arm/mach-davinci/include/mach/psc.h   |    1 +
 6 files changed, 403 insertions(+), 0 deletions(-)

