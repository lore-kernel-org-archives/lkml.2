Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0EFXtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:49:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6797 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0EFXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:49:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5974"; a="40611059"
From: Daniel Walker <dwalker@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
       Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] drivers: staging: dream: fix smd in makefile
Date: Thu,  6 May 2010 16:48:59 -0700
Message-Id: <1273189739-1710-1-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure about this one.. Cause if you apply this then some SMD files
don't compile anymore. There's some missing config options related to
AMSS.

NOT-Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
CC: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>
---
 drivers/staging/dream/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/Makefile b/drivers/staging/dream/Makefile
index 43d1eec..414a967 100644
--- a/drivers/staging/dream/Makefile
+++ b/drivers/staging/dream/Makefile
@@ -1,5 +1,6 @@
 EXTRA_CFLAGS=-Idrivers/staging/dream/include
-obj-$(CONFIG_MSM_ADSP)		+= qdsp5/ smd/
+obj-$(CONFIG_MSM_SMD)		+= smd/
+obj-$(CONFIG_MSM_ADSP)		+= qdsp5/
 obj-$(CONFIG_MSM_CAMERA)	+= camera/
 obj-$(CONFIG_INPUT_GPIO)	+= gpio_axis.o gpio_event.o gpio_input.o gpio_matrix.o gpio_output.o
 
-- 
1.7.0.4

