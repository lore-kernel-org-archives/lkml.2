Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2DQOBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:01:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46309 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab2DQOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:01:46 -0400
From: Laura Vasilescu <laura@rosedu.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, bskeggs@redhat.com, airlied@linux.ie,
        Laura Vasilescu <laura@rosedu.org>
Subject: [PATCH] drm: fix warning for uninitialized variable
Date: Tue, 17 Apr 2012 17:01:29 +0300
Message-Id: <1334671289-9869-1-git-send-email-laura@rosedu.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laura Vasilescu <laura@rosedu.org>
---
 drivers/gpu/drm/nouveau/nouveau_dp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index d996134..2ff17ef 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -332,7 +332,7 @@ dp_link_train_cr(struct drm_device *dev, struct dp_state *dp)
 static int
 dp_link_train_eq(struct drm_device *dev, struct dp_state *dp)
 {
-	bool eq_done, cr_done = true;
+	bool eq_done = false, cr_done = true;
 	int tries = 0, i;
 
 	dp_set_training_pattern(dev, dp, DP_TRAINING_PATTERN_2);
-- 
1.7.1

