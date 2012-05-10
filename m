Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2EJJRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:17:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54742 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab2EJJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:16:54 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 21/21] USB: serial: Changes to conform with checkpatch.sh script. trailing whitespace.
Date: Thu, 10 May 2012 19:17:27 +1000
Message-Id: <1336641447-23194-22-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
References: <1336641447-23194-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 1 checkpatch.sh error.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 001e11f..8f8df13 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -571,7 +571,7 @@ static void	usa28_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
 		tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty)) 
+		if (tty && !C_CLOCAL(tty))
 			tty_hangup(tty);
 		tty_kref_put(tty);
 	}
-- 
1.7.2.5

