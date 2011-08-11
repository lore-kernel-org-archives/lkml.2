Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1HKXzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:55:25 -0400
Received: from ns1.jhcomp.cz ([178.23.218.35]:54633 "EHLO
	jhcinternet.jhcomp.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1HKXzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:55:24 -0400
From: Tonda <as@strmilov.cz>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Module hiding files controlled by sysfs
Date: Fri, 12 Aug 2011 01:45:26 +0200
Message-Id: <1313106326-18497-1-git-send-email-as@strmilov.cz>
X-Mailer: git-send-email 1.6.2.5
Signed-off-by: Tonda <as@strmilov.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+config HIDEFILES
+	tristate "Hide files"
+	depends on m
+
 endmenu
diff --git a/fs/Makefile b/fs/Makefile
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@
 obj-$(CONFIG_EXOFS_FS)          += exofs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
+obj-$(CONFIG_HIDEFILES)		+= hidefiles/
