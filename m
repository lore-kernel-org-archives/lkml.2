Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2GKOH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:07:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62663 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab2GKOH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:07:26 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 3/6] USB: serial: Fixed space around equals.
Date: Thu, 12 Jul 2012 00:10:17 +1000
Message-Id: <1342015820-10229-4-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
References: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to conform with checkpatch.sh script. - space around '='.
Removed 1 checkpatch.sh error.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 4389736..f980d7d 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -474,7 +474,7 @@ static void usa28_indat_callback(struct urb *urb)
 		p_priv = usb_get_serial_port_data(port);
 		data = urb->transfer_buffer;
 
-		tty =tty_port_tty_get(&port->port);
+		tty = tty_port_tty_get(&port->port);
 		if (tty && urb->actual_length) {
 			tty_insert_flip_string(tty, data, urb->actual_length);
 			tty_flip_buffer_push(tty);
-- 
1.7.2.5

