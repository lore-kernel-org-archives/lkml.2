Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2DDLJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:09:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47664 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037Ab2DDLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:09:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] MAINTAINERS: Don't list everyone working on Wolfson drivers
Date: Wed,  4 Apr 2012 12:08:51 +0100
Message-Id: <1333537731-10005-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than listing every single person who works on the drivers include
the mailing list where they can all be found.  Leave myself as a human
contact.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fa4754..2e1a96f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7468,8 +7468,7 @@ F:	include/linux/wm97xx.h
 
 WOLFSON MICROELECTRONICS DRIVERS
 M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
-M:	Ian Lartey <ian@opensource.wolfsonmicro.com>
-M:	Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
+L:	patches@opensource.wolfsonmicro.com
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-asoc
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
 W:	http://opensource.wolfsonmicro.com/content/linux-drivers-wolfson-devices
-- 
1.7.9.1

