Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2KDPe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:34:29 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39760 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2KDPe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:34:27 -0500
Message-ID: <1352043258.11324.2.camel@phoenix>
Subject: [PATCH] tty: serial: max310x: Add terminating entry for
 spi_device_id table
From: Axel Lin <axel.lin@ingics.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 04 Nov 2012 23:34:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spi_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/tty/serial/max310x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 2bc28a5..1ab1d2c 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1239,6 +1239,7 @@ static int __devexit max310x_remove(struct spi_device *spi)
 static const struct spi_device_id max310x_id_table[] = {
 	{ "max3107",	MAX310X_TYPE_MAX3107 },
 	{ "max3108",	MAX310X_TYPE_MAX3108 },
+	{ }
 };
 MODULE_DEVICE_TABLE(spi, max310x_id_table);
 
-- 
1.7.9.5



