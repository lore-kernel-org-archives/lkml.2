Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2EMNuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:50:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2EMNuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:50:44 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 4/6] USB: serial: Changes to conform with checkpatch. - space near open parenthesis '('.
Date: Sun, 13 May 2012 23:52:38 +1000
Message-Id: <1336917160-27059-4-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336917160-27059-2-git-send-email-puzzleduck@gmail.com>
References: <1336917160-27059-2-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed 2 checkpatch.sh errors.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 425e113..49e814c 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -569,7 +569,7 @@ static void	usa28_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if( old_dcd_state != p_priv->dcd_state && old_dcd_state) {
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
 		tty = tty_port_tty_get(&port->port);
 		if (tty && !C_CLOCAL(tty)) 
 			tty_hangup(tty);
-- 
1.7.2.5

