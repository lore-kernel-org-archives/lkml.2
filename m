Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab2GKOHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:07:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab2GKOHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:07:32 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 4/6] USB: serial: Fixed space near open parenthesis.
Date: Thu, 12 Jul 2012 00:10:18 +1000
Message-Id: <1342015820-10229-5-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
References: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to conform with checkpatch.sh script. - space near open 
parenthesis '('. Removed 2 checkpatch.sh errors.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index f980d7d..50494f4 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -557,7 +557,7 @@ static void	usa28_instat_callback(struct urb *urb)
 	p_priv->dcd_state = ((msg->dcd) ? 1 : 0);
 	p_priv->ri_state = ((msg->ri) ? 1 : 0);
 
-	if( old_dcd_state != p_priv->dcd_state && old_dcd_state) {
+	if (old_dcd_state != p_priv->dcd_state && old_dcd_state) {
 		tty = tty_port_tty_get(&port->port);
 		if (tty && !C_CLOCAL(tty)) 
 			tty_hangup(tty);
-- 
1.7.2.5

