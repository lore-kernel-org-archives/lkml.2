Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1KRGAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 01:00:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33605 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab1KRGAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 01:00:31 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: pfg@sgi.com
Cc: linux-ia64@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 28/28] Drivers: tty: serial: ioc4_serial: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 23:00:24 -0700
Message-Id: <1321596024-10923-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/serial/ioc4_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index 6b36c15..bac4f07 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -2284,7 +2284,7 @@ static inline int do_read(struct uart_port *the_port, unsigned char *buf,
 								NCS_PARITY);
 					}
 					if ((*sc & IOC4_RXSB_FRAME_ERR) &&
-					   (port->ip_notify & N_FRAMING_ERROR)){
+					   (port->ip_notify & N_FRAMING_ERROR)) {
 						ioc4_cb_post_ncs(the_port,
 								NCS_FRAMING);
 					}
-- 
1.7.7.3

