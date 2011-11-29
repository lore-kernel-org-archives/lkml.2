Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1K2TlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:41:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61444 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab1K2Tjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:39:41 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, sjurbren@gmail.com,
        Paul Bolle <pebolle@tiscali.nl>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 5/9] xshm: genio dummy driver
Date: Tue, 29 Nov 2011 20:39:06 +0100
Message-Id: <1322595550-6473-6-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dummy driver for genio. A proper driver for Nova A9540 will be
contributed at a later stage.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/xshm/genio_dummy.c |   61 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/genio_dummy.c

diff --git a/drivers/xshm/genio_dummy.c b/drivers/xshm/genio_dummy.c
new file mode 100644
index 0000000..d359ee6
--- /dev/null
+++ b/drivers/xshm/genio_dummy.c
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2010
+ * Author:	Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+/* This is a dummy implementation of GENIO */
+
+#include <linux/c2c_genio.h>
+int genio_subscribe(int bit, void (*bit_set_cb)(void *data), void *data)
+{
+	return 0;
+}
+
+int genio_unsubscribe(int bit)
+{
+	return 0;
+}
+
+int genio_set_bit(int bit)
+{
+	return 0;
+}
+
+int genio_init(void)
+{
+	return 0;
+}
+
+void genio_exit(void)
+{
+}
+
+int genio_reset(void)
+{
+	return 0;
+}
+
+int genio_subscribe_caif_ready(void (*caif_ready_cb) (bool ready))
+{
+	return 0;
+}
+
+int genio_set_shm_addr(u32 addr, void (*ipc_ready_cb) (void))
+{
+	return 0;
+}
+
+int genio_bit_alloc(u32 setter_mask, u32 getter_mask)
+{
+	return 0;
+}
+
+void genio_register_errhandler(void (*errhandler)(int errno))
+{
+}
+
+int genio_power_req(int state)
+{
+	return 0;
+}
-- 
1.7.0.4

