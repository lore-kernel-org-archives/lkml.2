Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0K2NLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:11:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39968 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0K2NKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:10:39 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC v5 9/9] driver:staging:ti-st: Update TODO for FM V4L2 driver.
Date: Mon, 29 Nov 2010 09:18:43 -0500
Message-Id: <1291040323-2641-10-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1291040323-2641-9-git-send-email-manjunatha_halli@ti.com>
References: <1291040323-2641-1-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-2-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-3-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-4-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-5-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-6-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-7-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-8-git-send-email-manjunatha_halli@ti.com>
 <1291040323-2641-9-git-send-email-manjunatha_halli@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/staging/ti-st/TODO |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
index ebfd6bb..1d004cb 100644
--- a/drivers/staging/ti-st/TODO
+++ b/drivers/staging/ti-st/TODO
@@ -1,6 +1,21 @@
 TODO:
 
-1. Step up and maintain this driver to ensure that it continues
+1. Upstreaming BT driver
+
+2. Upstreaming FM driver
+
+	a. Use the new V4L2 control framework for all the V4L2 controls supported.
+
+	b. Change the interrupt handling mechanism as per comments by 'Hans Verkuil'.
+
+	c. Remove use of new V4L2 CID to set the BAND (US/JAPAN). Instead handle it
+	in driver.
+
+	d. Remove the new private CID defined for channel spacing instead handle it
+	in ioctl VIDIOC_S_HW_FREQ_SEEK.
+
+
+3. Step up and maintain this driver to ensure that it continues
 to work.  Having the hardware for this is pretty much a
 requirement.  If this does not happen, the will be removed in
 the 2.6.35 kernel release.
-- 
1.5.6.3

