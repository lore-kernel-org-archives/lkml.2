Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1BXSHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:07:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:6491 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab1BXSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:07:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,219,1297065600"; 
   d="scan'208";a="606213953"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com, christophe.guerard@intel.com
Subject: [PATCH 08/10] n_tracesink header file.
Date: Thu, 24 Feb 2011 10:07:02 -0800
Message-Id: <1298570824-26085-9-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This header file allows the n_tracerouter to send it's information
to the n_tracesink ldisc driver.  It's part of the Intel-Atom
PTI implementation solution.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/tty/n_tracesink.h |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/n_tracesink.h

diff --git a/drivers/tty/n_tracesink.h b/drivers/tty/n_tracesink.h
new file mode 100644
index 0000000..10ab772
--- /dev/null
+++ b/drivers/tty/n_tracesink.h
@@ -0,0 +1,36 @@
+/*
+ *  n_tracesink.h - Kernel driver API to route trace data in kernel space.
+ *
+ *  Copyright (C) Intel 2011
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * The PTI (Parallel Trace Interface) driver directs trace data routed from
+ * various parts in the system out through the Intel Penwell PTI port and
+ * out of the mobile device for analysis with a debugging tool
+ * (Lauterbach, Fido). This is part of a solution for the MIPI P1149.7,
+ * compact JTAG, standard.
+ * 
+ * This header file is used by n_tracerouter to be able to send the 
+ * data of it's tty port to the tty port this module sits.  This
+ * mechanism can also be used independent of the PTI module.
+ *
+ */
+
+#ifndef N_TRACESINK_H_
+#define N_TRACESINK_H_
+
+void n_tracesink_datadrain(u8 *buf, int count);
+
+#endif
-- 
1.7.2.3

