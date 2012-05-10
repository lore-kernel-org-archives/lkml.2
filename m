Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2EJJWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:22:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37217 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2EJJPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:15:36 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Minerds <puzzleduck@gmail.com>
Subject: [PATCH 06/21] USB: serial: Changes to conform with checkpatch.sh script. white space around '('
Date: Thu, 10 May 2012 19:17:12 +1000
Message-Id: <1336641447-23194-7-git-send-email-puzzleduck@gmail.com>
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
index a6fc2be..40806d0 100644
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

