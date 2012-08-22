Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2HVHHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:07:35 -0400
Received: from mail.telros.ru ([83.136.244.21]:58655 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab2HVHHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:07:05 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 04/10] staging: media: go7007: Add IDENT for TW2802/2804
Date: Wed, 22 Aug 2012 14:45:13 +0400
Message-Id: <1345632319-23224-4-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 include/media/v4l2-chip-ident.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 7395c81..5395495 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -113,6 +113,10 @@ enum {
 	/* module vp27smpx: just ident 2700 */
 	V4L2_IDENT_VP27SMPX = 2700,
 
+	/* module wis-tw2804: 2802/2804 */
+	V4L2_IDENT_TW2802 = 2802,
+	V4L2_IDENT_TW2804 = 2804,
+
 	/* module vpx3220: reserved range: 3210-3229 */
 	V4L2_IDENT_VPX3214C = 3214,
 	V4L2_IDENT_VPX3216B = 3216,
-- 
1.7.7.6

