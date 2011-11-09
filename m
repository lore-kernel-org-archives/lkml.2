Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1KIViD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:38:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62281 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab1KIVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:37:59 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: rdunlap@xenotime.net, dmitry.torokhov@gmail.com, grant.likely@secretlab.ca,
        ricardo.ribalda@gmail.com, jic23@cam.ac.uk, aghayal@codeaurora.org,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, alan@linux.intel.com,
        david@hardeman.nu, Shubhrajyoti@ti.com, saaguirre@ti.com,
        hemanthv@ti.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCHv6_input/next 5/5] input/cma3000_d0x: Match comment to name of struct
Date: Wed,  9 Nov 2011 22:37:32 +0100
Message-Id: <1320874652-18371-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320874652-18371-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1320874652-18371-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
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
1.7.7.2

