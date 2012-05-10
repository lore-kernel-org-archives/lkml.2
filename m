Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab2EJJQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:16:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab2EJJP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:15:58 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 09/21] USB: serial: Changes to conform with checkpatch.sh script. spaces required around '?' and ':'.
Date: Thu, 10 May 2012 19:17:15 +1000
Message-Id: <1336641447-23194-10-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 2 checkpatch.sh errors.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 6e9d8a6..0c952eb 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1134,7 +1134,7 @@ static int keyspan_open(struct tty_struct *tty, struct usb_serial_port *port)
 	}
 	/* set CTS/RTS handshake etc. */
 	p_priv->cflag = cflag;
-	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
+	p_priv->flow_control = (cflag & CRTSCTS) ? flow_cts : flow_none;
 
 	keyspan_send_setup(port, 1);
 	/* mdelay(100); */
-- 
1.7.2.5

