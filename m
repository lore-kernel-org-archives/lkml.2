Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab1JNMkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:40:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52927 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932891Ab1JNMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:38:40 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Constify constraints name
Date: Fri, 14 Oct 2011 13:38:38 +0100
Message-Id: <1318595918-20716-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for the API to modify it and having it const makes it
easier to use with random strings the board code has.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/machine.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index ce3127a..f3f13fd 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -95,7 +95,7 @@ struct regulator_state {
  */
 struct regulation_constraints {
 
-	char *name;
+	const char *name;
 
 	/* voltage output range (inclusive) - for voltage control */
 	int min_uV;
-- 
1.7.6.3

