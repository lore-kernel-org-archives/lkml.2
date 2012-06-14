Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2FNAb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:31:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56686 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2FNAb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:31:28 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] writeback: Maintainer Record
Date: Thu, 14 Jun 2012 08:31:13 +0800
Message-Id: <1339633873-12729-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Add a maintainer record for the writeback subsystem.

Targeted for git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14bc707..582c5ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7595,6 +7595,16 @@ F:	include/linux/workqueue.h
 F:	kernel/workqueue.c
 F:	Documentation/workqueue.txt
 
+WRITEBACK
+M:  Fengguang Wu <fengguang.wu@intel.com>
+T:  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback
+S:  Maintained
+F:  include/linux/backing-dev.h
+F:  mm/backing-dev.c
+F:  include/linux/writeback.h
+F:  fs/fs-writeback.c
+F:  mm/page-writeback.c
+
 X.25 NETWORK LAYER
 M:	Andrew Hendry <andrew.hendry@gmail.com>
 L:	linux-x25@vger.kernel.org
-- 
1.7.9.5

