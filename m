Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2CEQQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:16:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65482 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2CEQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:16:49 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de
Subject: [PATCH 00/14] dmaengine: imx-dma: merge dma arch code into dmaengine.
Date: Mon,  5 Mar 2012 17:16:22 +0100
Message-Id: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
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

[PATCH 01/14] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
[PATCH 02/14] dmaengine: imx-dma: remove data member form internal structure.
[PATCH 03/14] dmaengine: imx-dma: remove dma_mode member of internal structure.
[PATCH 04/14] dmaengine: imx-dma: remove 'imxdma_setup_mem2mem_hw' function.
[PATCH 05/14] dmaengine: imx-dma: remove 'imxdma_config_channel_hw' function.
[PATCH 06/14] dmaengine: imx-dma: remove 'imxdma_setup_sg_hw' function.
[PATCH 07/14] dmaengine: imx-dma: remove sg member from internal structure.
[PATCH 08/14] dmaengine: imx-dma: remove in_use field of internal structure.
[PATCH 09/14] dmaengine: imx-dma: remove resbytes field of internal structure.
[PATCH 10/14] dmaengine: imx-dma: remove internal structure.
[PATCH 11/14] dmaengine: imx-dma: remove unused arg of imxdma_sg_next.
[PATCH 12/14] dmaengine: imx-dma: integrate 'imx_dmav1_baseaddr' and 'dma_clk' inside dmaengine structure.
[PATCH 13/14] dmaengine: imx-dma: use dev_dbg and dev_warn for messages.
[PATCH 14/14] dmaengine: imx-dma: remove  dma-v1.c and dma-v1.h
