Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2E1OUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:20:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2E1OT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:19:58 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 5/6] USB: serial: Changes to conform with checkpatch.sh script. - trailing whitespace.
Date: Tue, 29 May 2012 00:21:59 +1000
Message-Id: <1338214920-32708-6-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
References: <1338214920-32708-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 1 checkpatch.sh error.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 50494f4..f205e9b 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -559,7 +559,7 @@ static void	usa28_instat_callback(struct urb *urb)
 
 	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
 		tty = tty_port_tty_get(&port->port);
-		if (tty && !C_CLOCAL(tty)) 
+		if (tty && !C_CLOCAL(tty))
 			tty_hangup(tty);
 		tty_kref_put(tty);
 	}
-- 
1.7.2.5

