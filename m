Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2AaIuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:50:25 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46561 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314Ab2AaItE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:49:04 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RESEND PATCHv5 05/11] modem_shm: genio dummy driver
Date: Tue, 31 Jan 2012 09:48:40 +0100
Message-Id: <1327999726-8774-6-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dummy driver for genio. A proper driver for Nova A9540
will be contributed at a later stage.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/modem_shm/dummy_c2c_genio.c |   76 +++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 drivers/modem_shm/dummy_c2c_genio.c

diff --git a/drivers/modem_shm/dummy_c2c_genio.c b/drivers/modem_shm/dummy_c2c_genio.c
new file mode 100644
index 0000000..18fbb6f
--- /dev/null
+++ b/drivers/modem_shm/dummy_c2c_genio.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2012
+ * Author:	Sjur Brændeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+/* This is a dummy implementation of GENIO */
+
+#include <linux/module.h>
+#include <linux/c2c_genio.h>
+
+int genio_subscribe(int bit, void (*bit_set_cb)(void *data), void *data)
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_subscribe);
+
+int genio_unsubscribe(int bit)
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_unsubscribe);
+
+int genio_set_bit(int bit)
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_set_bit);
+
+int genio_reset(void)
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_reset);
+
+int genio_subscribe_caif_ready(void (*caif_ready_cb) (bool ready))
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_subscribe_caif_ready);
+
+int genio_set_shm_addr(u32 addr, void (*ipc_ready_cb) (void))
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_set_shm_addr);
+
+int genio_bit_alloc(u32 setter_mask, u32 getter_mask)
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_bit_alloc);
+
+void genio_register_errhandler(void (*errhandler)(int errno))
+{
+}
+EXPORT_SYMBOL(genio_register_errhandler);
+
+int genio_power_req(int state)
+{
+	return 0;
+}
+EXPORT_SYMBOL(genio_power_req);
+
+static int __init genio_init(void)
+{
+	return 0;
+}
+
+static void __exit genio_exit(void)
+{
+}
+module_init(genio_init);
+module_exit(genio_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

