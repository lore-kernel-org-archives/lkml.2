Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2KWQZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:25:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59613 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2KWQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 11:25:24 -0500
From: Javi Merino <javi.merino@arm.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Javi Merino <javi.merino@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] of: add missing documentation for of_platform_populate()
Date: Fri, 23 Nov 2012 16:25:08 +0000
Message-Id: <1353687908-17215-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 23 Nov 2012 16:25:21.0106 (UTC) FILETIME=[21FC9B20:01CDC997]
X-MC-Unique: 112112316252202201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qANGPTuL013850

15c3597d (dt/platform: allow device name to be overridden) added a
lookup parameter to of_platform_populate() but did not update the
documentation.  This patch adds the missing documentation entry.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 drivers/of/platform.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b80891b..e0a6514 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -436,6 +436,7 @@ EXPORT_SYMBOL(of_platform_bus_probe);
  * of_platform_populate() - Populate platform_devices from device tree data
  * @root: parent of the first level to probe or NULL for the root of the tree
  * @matches: match table, NULL to use the default
+ * @lookup: auxdata table for matching id and platform_data with device nodes
  * @parent: parent to hook devices from, NULL for toplevel
  *
  * Similar to of_platform_bus_probe(), this function walks the device tree
-- 
1.7.9.5


