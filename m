Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1HQKgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:36:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53648 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1HQKgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:36:16 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <g.liakhovetski@gmx.de>, <mchehab@infradead.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH] V4L/DVB: Add chip ID of TVP5146 video decoder
Date: Wed, 17 Aug 2011 16:06:05 +0530
Message-ID: <1313577365-18516-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

This patch is to add chip identifier entry for
TVP5146 video decoder.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 include/media/v4l2-chip-ident.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 63fd9d3..cd9b66f 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -122,6 +122,9 @@ enum {
 	/* Other via devs could use 3314, 3324, 3327, 3336, 3364, 3353 */
 	V4L2_IDENT_VIA_VX855 = 3409,
 
+	/* module tvp514x */
+	V4L2_IDENT_TVP5146 = 5146,
+
 	/* module tvp5150 */
 	V4L2_IDENT_TVP5150 = 5150,
 
-- 
1.7.0.4

