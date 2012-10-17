Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2JQOQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:16:39 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51234 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab2JQOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:16:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] drivers: cma: Fix wrong CMA selected region size default value
Date: Wed, 17 Oct 2012 16:17:22 +0200
Message-Id: <1350483442-13180-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig lists CMA_SIZE_SEL_ABSOLUTE as the default value fo the CMA
selected region size, but that option isn't available in the defined
choices. Set the default to CMA_SIZE_SEL_MBYTES instead.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/base/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 08b4c52..b34b5cd 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -236,7 +236,7 @@ config CMA_SIZE_PERCENTAGE
 
 choice
 	prompt "Selected region size"
-	default CMA_SIZE_SEL_ABSOLUTE
+	default CMA_SIZE_SEL_MBYTES
 
 config CMA_SIZE_SEL_MBYTES
 	bool "Use mega bytes value only"
-- 
Regards,

Laurent Pinchart

