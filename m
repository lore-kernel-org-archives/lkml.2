Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2JAUt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:49:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58885 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab2JAUtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:49:25 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] MAINTAINERS: add scripts/dtc under Devicetree maintainers
Date: Mon,  1 Oct 2012 15:49:06 -0500
Message-Id: <1349124546-16864-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

scripts/dtc has no explicit in kernel maintainer, so add it under
Devicetree maintainers.

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 94b823f..2d7eaba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5035,6 +5035,7 @@ S:	Maintained
 F:	Documentation/devicetree
 F:	drivers/of
 F:	include/linux/of*.h
+	scripts/dtc
 K:	of_get_property
 K:	of_match_table
 
-- 
1.7.9.5

