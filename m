Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2EJJQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:16:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab2EJJQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:16:41 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 18/21] USB: serial: Changes to conform with checkpatch.sh script. spaces required around '?' and ':'.
Date: Thu, 10 May 2012 19:17:24 +1000
Message-Id: <1336641447-23194-19-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 3 checkpatch.sh errors.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 7c7b53e..d4ae12d 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2219,7 +2219,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 		msg.txMode = TXMODE_BYHAND;
 	}
 
-	msg.lcr = (p_priv->cflag & CSTOPB)? STOPBITS_678_2: STOPBITS_5678_1;
+	msg.lcr = (p_priv->cflag & CSTOPB) ? STOPBITS_678_2 : STOPBITS_5678_1;
 	switch (p_priv->cflag & CSIZE) {
 	case CS5:
 		msg.lcr |= USA_DATABITS_5;
@@ -2236,7 +2236,7 @@ static int keyspan_usa90_send_setup(struct usb_serial *serial,
 	}
 	if (p_priv->cflag & PARENB) {
 		/* note USA_PARITY_NONE == 0 */
-		msg.lcr |= (p_priv->cflag & PARODD)?
+		msg.lcr |= (p_priv->cflag & PARODD) ?
 			USA_PARITY_ODD : USA_PARITY_EVEN;
 	}
 	if (p_priv->old_cflag != p_priv->cflag) {
-- 
1.7.2.5

