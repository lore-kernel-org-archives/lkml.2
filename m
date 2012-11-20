Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2KTVbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:31:09 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56467 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833Ab2KTVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:31:08 -0500
Message-ID: <1353447066.19434.25.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] radeon: Fix typo and copy/paste error in comments
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 20 Nov 2012 22:31:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2012 21:31:06.0486 (UTC) FILETIME=[59723160:01CDC766]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely ntested.

 drivers/gpu/drm/radeon/radeon_ring.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 47634f2..ebd6956 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -459,7 +459,7 @@ void radeon_ring_unlock_commit(struct radeon_device *rdev, struct radeon_ring *r
  *
  * @ring: radeon_ring structure holding ring information
  *
- * Reset the driver's copy of the wtpr (all asics).
+ * Reset the driver's copy of the wptr (all asics).
  */
 void radeon_ring_undo(struct radeon_ring *ring)
 {
@@ -503,7 +503,7 @@ void radeon_ring_force_activity(struct radeon_device *rdev, struct radeon_ring *
 }
 
 /**
- * radeon_ring_force_activity - update lockup variables
+ * radeon_ring_lockup_update - update lockup variables
  *
  * @ring: radeon_ring structure holding ring information
  *
-- 
1.7.7.6

