Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0JJGsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 02:48:19 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:42017 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab0JJGsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 02:48:17 -0400
Content-transfer-encoding: 7BIT
From: Alon Ziv <alon+git@nolaviz.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alon Ziv <alon+git@nolaviz.org>
Subject: [PATCH 3/3] Whitespace fixes in opticon driver
Date: Sun, 10 Oct 2010 08:32:20 +0200
Message-id: <1286692340-18639-4-git-send-email-alon-git@nolaviz.org>
X-Mailer: git-send-email 1.6.3.3
In-reply-to: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org>
References: <1286692340-18639-1-git-send-email-alon-git@nolaviz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alon Ziv <alon-git@nolaviz.org>
---
 drivers/usb/serial/opticon.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 4fe7c3d..eda1f92 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -108,10 +108,10 @@ static void opticon_bulk_callback(struct urb *urb)
 				else
 					priv->rts = true;
 			} else {
-			dev_dbg(&priv->udev->dev,
-				"Unknown data packet received from the device:"
-				" %2x %2x\n",
-				data[0], data[1]);
+				dev_dbg(&priv->udev->dev,
+					"Unknown data packet received from the device:"
+					" %2x %2x\n",
+					data[0], data[1]);
 			}
 		}
 	} else {
-- 
1.6.3.3

