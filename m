Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1KRGKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 01:10:52 -0500
Received: from mail-gy0-f179.google.com ([209.85.160.179]:59707 "EHLO
	mail-gy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab1KRGKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 01:10:50 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 01:10:49 EST
From: Zac Storer <zac.3.14159@gmail.com>
To: leitao@linux.vnet.ibm.com
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 29/29] Drivers: tty: serial: jsm: jsm_tty: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 23:03:02 -0700
Message-Id: <1321596182-11031-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/serial/jsm/jsm_tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 434bd88..49fded1 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -473,7 +473,7 @@ int jsm_uart_port_init(struct jsm_board *brd)
 			set_bit(line, linemap);
 		brd->channels[i]->uart_port.line = line;
 		rc = uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port);
-		if (rc){
+		if (rc) {
 			printk(KERN_INFO "jsm: Port %d failed. Aborting...\n", i);
 			return rc;
 		}
-- 
1.7.7.3

