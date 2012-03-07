Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2CGOd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:33:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33666 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab2CGOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:33:56 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de
Subject: [PATCH v2 00/13] dmaengine: imx-dma: merge dma arch code into dmaengine.
Date: Wed,  7 Mar 2012 15:33:32 +0100
Message-Id: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series have to be applied on top of the following patches:
[PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
[PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.

As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
is deprecated and no new patches are accepted for it.

This series merges this code into the imx-dma.c dmaengine driver.

Changes since v1:
 - Merge patch 14 with 01.
 - Add a proper changelog to each patch of the series.

[PATCH v2 01/13] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
[PATCH v2 02/13] dmaengine: imx-dma: remove data member from internal structure.
[PATCH v2 03/13] dmaengine: imx-dma: remove dma_mode member of internal structure.
[PATCH v2 04/13] dmaengine: imx-dma: remove 'imxdma_setup_mem2mem_hw' function.
[PATCH v2 05/13] dmaengine: imx-dma: remove 'imxdma_config_channel_hw' function.
[PATCH v2 06/13] dmaengine: imx-dma: remove 'imxdma_setup_sg_hw' function.
[PATCH v2 07/13] dmaengine: imx-dma: remove sg member from internal structure.
[PATCH v2 08/13] dmaengine: imx-dma: remove 'in_use' field of 'internal' structure.
[PATCH v2 09/13] dmaengine: imx-dma: remove 'resbytes' field of 'internal' structure.
[PATCH v2 10/13] dmaengine: imx-dma: remove internal structure.
[PATCH v2 11/13] dmaengine: imx-dma: remove unused arg of imxdma_sg_next.
[PATCH v2 12/13] dmaengine: imx-dma: remove 'imx_dmav1_baseaddr' and 'dma_clk'.
[PATCH v2 13/13] dmaengine: imx-dma: use 'dev_dbg' and 'dev_warn' for messages.
