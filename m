Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab1BSVgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 16:36:23 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:42889 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1BSVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 16:36:22 -0500
Subject: [PATCH] [TRIVIAL] drm: drop commented out code and preceding comment
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Date: Sat, 19 Feb 2011 22:35:55 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1298151381.1977.7.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r100_gpu_init() was dropped in 90aca4d ("drm/radeon/kms: simplify &
improve GPU reset V2") but here it was only commented out.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpu/drm/radeon/r100.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index ac493ec..e0f7fd9 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3746,8 +3746,6 @@ static int r100_startup(struct radeon_device *rdev)
 	r100_mc_program(rdev);
 	/* Resume clock */
 	r100_clock_startup(rdev);
-	/* Initialize GPU configuration (# pipes, ...) */
-//	r100_gpu_init(rdev);
 	/* Initialize GART (initialize after TTM so we can allocate
 	 * memory through TTM but finalize after TTM) */
 	r100_enable_bm(rdev);
-- 
1.7.4.1



