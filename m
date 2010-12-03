Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab0LCLnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:43:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34967 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab0LCLmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:42:52 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC v6 9/9] driver:staging:ti-st: Update TODO for FM V4L2 driver.
Date: Fri,  3 Dec 2010 07:50:31 -0500
Message-Id: <1291380631-25993-10-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1291380631-25993-9-git-send-email-manjunatha_halli@ti.com>
References: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-2-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-3-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-4-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-5-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-6-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-7-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-8-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-9-git-send-email-manjunatha_halli@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/staging/ti-st/TODO |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
index ebfd6bb..002635d 100644
--- a/drivers/staging/ti-st/TODO
+++ b/drivers/staging/ti-st/TODO
@@ -1,6 +1,14 @@
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
+3. Step up and maintain this driver to ensure that it continues
 to work.  Having the hardware for this is pretty much a
 requirement.  If this does not happen, the will be removed in
 the 2.6.35 kernel release.
-- 
1.5.6.3

