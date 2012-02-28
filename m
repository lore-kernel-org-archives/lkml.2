Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965733Ab2B1QId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:08:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37336 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917Ab2B1QIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:08:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.180.101.72 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, s.hauer@pengutronix.de, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] dmaengine: i.MX DMA series.
Date: Tue, 28 Feb 2012 17:08:16 +0100
Message-Id: <1330445298-3522-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it seems Vinod's and Sascha's possition regarding
to the file arch/arm/mach-imx/dma-v1.c is so strong
this is a resent of the series dropping patches 2 and 3.

[PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
[PATCH v2 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
