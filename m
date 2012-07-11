Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2GKOHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:07:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab2GKOHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:07:47 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: gregkh@linuxfoundation.org, richard.weinberger@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        puzzleduck@gmail.com
Subject: [PATCH 6/6] USB: serial: Removed unrequired parentheses.
Date: Thu, 12 Jul 2012 00:10:20 +1000
Message-Id: <1342015820-10229-7-git-send-email-puzzleduck@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
References: <1342015820-10229-1-git-send-email-puzzleduck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to conform with checkpatch.sh script. - return is not a 
function, parentheses not required. Removed 1 checkpatch.sh error.

Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
---
 drivers/usb/serial/keyspan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index f205e9b..ccb24e6 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1240,7 +1240,7 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 
 	if (request_ihex_firmware(&fw, fw_name, &serial->dev->dev)) {
 		dev_err(&serial->dev->dev, "Required keyspan firmware image (%s) unavailable.\n", fw_name);
-		return(1);
+		return 1;
 	}
 
 	dbg("Uploading Keyspan %s firmware.", fw_name);
-- 
1.7.2.5

