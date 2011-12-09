Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1LIOIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:08:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41606 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1LIOH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:07:57 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 05/10] xshm: genio dummy driver
Date: Fri,  9 Dec 2011 15:07:23 +0100
Message-Id: <1323439648-22697-6-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
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
 drivers/xshm/dummy_c2c_genio.c |   76 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/dummy_c2c_genio.c

diff --git a/drivers/xshm/dummy_c2c_genio.c b/drivers/xshm/dummy_c2c_genio.c
new file mode 100644
index 0000000..30d3240
--- /dev/null
+++ b/drivers/xshm/dummy_c2c_genio.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2010
+ * Author:	Sjur Brendeland / sjur.brandeland@stericsson.com
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

