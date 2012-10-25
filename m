Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935647Ab2JYNWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:22:43 -0400
Received: from forward1.mail.yandex.net ([77.88.46.6]:54462 "EHLO
	forward1.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab2JYNWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:22:41 -0400
From: Igor Murzov <e-mail@date.by>
To: Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Igor Murzov <e-mail@date.by>
Subject: [PATCH 1/2] drm/radeon: fix ATPX function documentation
Date: Thu, 25 Oct 2012 17:09:00 +0400
Message-Id: <1351170541-22570-1-git-send-email-e-mail@date.by>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a copy&pasted documentation.

Signed-off-by: Igor Murzov <e-mail@date.by>
---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index 37f6a90..15f5ded 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -352,9 +352,9 @@ static int radeon_atpx_switchto(enum vga_switcheroo_client_id id)
 }
 
 /**
- * radeon_atpx_switchto - switch to the requested GPU
+ * radeon_atpx_power_state - power down/up the requested GPU
  *
- * @id: GPU to switch to
+ * @id: GPU to power down/up
  * @state: requested power state (0 = off, 1 = on)
  *
  * Execute the necessary ATPX function to power down/up the discrete GPU
-- 
1.7.12.1

