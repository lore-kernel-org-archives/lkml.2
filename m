Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1LHWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:16:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58174 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1LHWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:16:25 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] MAINTAINERS: Fix pinctrl subsystem's directory
Date: Thu,  8 Dec 2011 15:16:19 -0700
Message-Id: <1323382579-14950-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e29683d..816fb03 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5174,7 +5174,7 @@ F:	drivers/mtd/devices/phram.c
 PIN CONTROL SUBSYSTEM
 M:	Linus Walleij <linus.walleij@linaro.org>
 S:	Maintained
-F:	drivers/pinmux/
+F:	drivers/pinctrl/
 
 PKTCDVD DRIVER
 M:	Peter Osterlund <petero2@telia.com>
-- 
1.7.0.4

