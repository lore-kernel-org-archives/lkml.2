Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2ILRFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:05:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51789 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760785Ab2ILRDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:41 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Cesar Miquel <miquel@df.uba.ar>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rio500-users@lists.sourceforge.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] drivers/usb/misc/rio500.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:20 +0200
Message-Id: <1347469402-27557-13-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/usb/misc/rio500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 1084124..b9b356a 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -338,7 +338,7 @@ write_rio(struct file *file, const char __user *buffer,
 				thistime -= partial;
 			} else
 				break;
-		};
+		}
 		if (result) {
 			dev_err(&rio->rio_dev->dev, "Write Whoops - %x\n",
 				result);

