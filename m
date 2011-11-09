Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1KIOmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:42:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33945 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1KIOmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:42:09 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <samuel.ortiz@intel.com>, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH] mfd: twl6040: Fix wrong TWL6040_GPO3 bitfield value
Date: Wed, 9 Nov 2011 08:42:04 -0600
Message-ID: <1320849724-1750-1-git-send-email-saaguirre@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The define should be the result of 1 << Bit number.

Bit number for GPOCTL.GPO3 field is 2, which results
in 0x4 value.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/mfd/twl6040.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 2463c261..2a7ff16 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -142,7 +142,7 @@
 
 #define TWL6040_GPO1			0x01
 #define TWL6040_GPO2			0x02
-#define TWL6040_GPO3			0x03
+#define TWL6040_GPO3			0x04
 
 /* ACCCTL (0x2D) fields */
 
-- 
1.7.5.4

