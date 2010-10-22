Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0JVXzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:55:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab0JVXzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F2cY6DMNEoajZ8RGJecCFZiaZki4QRy6Sme0SeAuZjmVzIvEX9NRKjypAS0rvPySRg
         84G6KoQrHeqYCYyPx2/ljIvj+ssNovNHCzwLR/H971GXHu1dNVN4sUJ9KR0DA8qxPbKv
         e2TvMKXMYiLp6PYgKCc1pYBI5uuZmLj+gDUu0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 27/29] memstick: jmb38x_ms: minor additions.
Date: Sat, 23 Oct 2010 01:53:55 +0200
Message-Id: <1287791637-10329-28-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add my copyright
* Add module param descriprion

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 86c003a..0a1bb25 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -2,6 +2,7 @@
  *  jmb38x_ms.c - JMicron jmb38x MemoryStick card reader
  *
  *  Copyright (C) 2008 Alex Dubov <oakad@yahoo.com>
+ *  Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -955,13 +956,15 @@ static void __exit j38ms_exit(void)
 }
 
 MODULE_AUTHOR("Alex Dubov");
-MODULE_DESCRIPTION("JMicron jmb38x MemoryStick driver");
+MODULE_DESCRIPTION("JMicron jm38x_ms MemoryStick driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, j38ms_id_tbl);
 
-module_param(no_dma, bool, S_IRUGO);
-module_param(debug, bool, S_IRUGO);
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Debug level (0-3)");
 
+module_param(no_dma, bool, 0644);
+MODULE_PARM_DESC(no_dma, "Disable the dma");
 
 module_init(j38ms_init);
 module_exit(j38ms_exit);
-- 
1.7.1

