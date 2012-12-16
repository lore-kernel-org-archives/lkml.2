Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2LPRZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:25:00 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43769 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2LPRY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 06/14] shmobile-iommu: Sort header files alphabetically
Date: Sun, 16 Dec 2012 18:25:52 +0100
Message-Id: <1355678760-27357-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-iommu.c |   10 +++++-----
 drivers/iommu/shmobile-ipmmu.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index bbbf1bc..9f2243e3 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -17,14 +17,14 @@
  *
  */
 
-#include <linux/io.h>
+#include <asm/dma-iommu.h>
+#include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
-#include <linux/slab.h>
-#include <linux/platform_device.h>
+#include <linux/io.h>
 #include <linux/iommu.h>
-#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <mach/ipmmu.h>
-#include <asm/dma-iommu.h>
 
 #define L1_SIZE CONFIG_SHMOBILE_IOMMU_L1SIZE
 #define L1_LEN (L1_SIZE / 4)
diff --git a/drivers/iommu/shmobile-ipmmu.c b/drivers/iommu/shmobile-ipmmu.c
index d6df0b4..edec3b8 100644
--- a/drivers/iommu/shmobile-ipmmu.c
+++ b/drivers/iommu/shmobile-ipmmu.c
@@ -17,10 +17,10 @@
  *
  */
 
-#include <linux/platform_device.h>
-#include <linux/io.h>
 #include <linux/err.h>
 #include <linux/export.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <mach/ipmmu.h>
 
-- 
1.7.8.6

