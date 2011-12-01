Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1LAVym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:54:42 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36270
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754069Ab1LAVyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:54:41 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] hv: Update MAINTAINERS
Date: Thu,  1 Dec 2011 13:54:46 -0800
Message-Id: <1322776486-17077-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the MAINTAINERS file to reflect the current state
of the Hyper-V drivers.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 MAINTAINERS |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3523ab0..db6cee2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3197,6 +3197,27 @@ M:	William Irwin <wli@holomorphy.com>
 S:	Maintained
 F:	fs/hugetlbfs/
 
+Hyper-V CORE DRIVERS
+M:	K. Y. Srinivasan <kys@microsoft.com>
+M:	Haiyang Zhang <haiyangz@microsoft.com>
+L:	devel@linuxdriverproject.org
+S:	Maintained
+F:	drivers/hv/
+
+Hyper-V MOUSE DRIVER
+M:	K. Y. Srinivasan <kys@microsoft.com>
+M:	Haiyang Zhang <haiyangz@microsoft.com>
+L:	devel@linuxdriverproject.org
+S:	Maintained
+F:	drivers/hid/hid-hyperv.c
+
+Hyper-V NETWORK DRIVER
+M:	K. Y. Srinivasan <kys@microsoft.com>
+M:	Haiyang Zhang <haiyangz@microsoft.com>
+L:	devel@linuxdriverproject.org
+S:	Maintained
+F:	drivers/net/hyperv/
+
 I2C/SMBUS STUB DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	linux-i2c@vger.kernel.org
@@ -6323,9 +6344,9 @@ S:	Odd Fixes
 F:	drivers/staging/frontier/
 
 STAGING - HYPER-V (MICROSOFT)
-M:	Hank Janssen <hjanssen@microsoft.com>
+M:	K. Y. Srinivasan <kys@microsoft.com>
 M:	Haiyang Zhang <haiyangz@microsoft.com>
-S:	Odd Fixes
+S:	Maintained
 F:	drivers/staging/hv/
 
 STAGING - INDUSTRIAL IO
-- 
1.7.4.1

