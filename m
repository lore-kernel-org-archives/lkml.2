Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1JXUVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:21:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59894 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1JXUVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:21:42 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, grant.likely@secretlab.ca,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, jic23@cam.ac.uk,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv4 6/6] input/cma3000_d0x: Match comment to name of struct
Date: Mon, 24 Oct 2011 22:21:16 +0200
Message-Id: <1319487676-27181-7-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1319487676-27181-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---

v4: Add ACKs to patch

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 include/linux/input/cma3000.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/input/cma3000.h b/include/linux/input/cma3000.h
index cbbaac2..e8c28e8 100644
--- a/include/linux/input/cma3000.h
+++ b/include/linux/input/cma3000.h
@@ -33,7 +33,7 @@
 #define CMARANGE_8G   8000
 
 /**
- * struct cma3000_i2c_platform_data - CMA3000 Platform data
+ * struct cma3000_platform_data - CMA3000 Platform data
  * @fuzz_x: Noise on X Axis
  * @fuzz_y: Noise on Y Axis
  * @fuzz_z: Noise on Z Axis
-- 
1.7.7

