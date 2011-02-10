Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1BJJzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:55:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:11844 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab1BJJzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:32 -0500
Message-Id: <b7da2f$qd3ni0@fmsmga001.fm.intel.com>
Date: 10 Feb 2011 01:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="886169156"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 12/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/mei_version.h b/drivers/char/mei/mei_version.h
new file mode 100644
index 0000000..f434636
--- /dev/null
+++ b/drivers/char/mei/mei_version.h
@@ -0,0 +1,35 @@
+/*
+ *
+ * Intel(R) Management Engine Interface (Intel(R) MEI) Linux driver
+ * Copyright (c) 2003-2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+
+#ifndef MEI_VERSION_H
+#define MEI_VERSION_H
+
+#define MAJOR_VERSION		7
+#define MINOR_VERSION		1
+#define QUICK_FIX_NUMBER	22
+#define VER_BUILD		1
+
+#define MEI_DRV_VER1 __stringify(MAJOR_VERSION) "." __stringify(MINOR_VERSION)
+#define MEI_DRV_VER2 __stringify(QUICK_FIX_NUMBER) "." __stringify(VER_BUILD)
+
+#define MEI_DRIVER_VERSION	MEI_DRV_VER1 "." MEI_DRV_VER2
+
+#endif


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

