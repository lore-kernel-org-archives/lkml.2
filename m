Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab2BJOcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:32:01 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59971 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2BJOcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:32:00 -0500
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dmaengine: i.MX DMA series.
Date: Fri, 10 Feb 2012 15:31:36 +0100
Message-Id: <1328884300-18801-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1-3 have already been sent to the list (not merged yet) 
but they are submitted so that everyone can get the whole picture
of what we're trying to do here.

A new patch(4) has been added which adds support for multiple 
descriptors.

[PATCH 1/4] dmaengine: Add support for MEMCPY for imx-dma.
[PATCH 2/4] i.MX DMA: Add support for 2D transfers.
[PATCH 3/4] dmaengine: i.MX: Add support for interleaved transfers.
[PATCH 4/4] dmaengine: Add support for multiple descriptors for imx-dma.
