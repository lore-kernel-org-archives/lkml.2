Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab2LMOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:25:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44943 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab2LMOMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 193/241] USB: mos7840: remove unused variable
Date: Thu, 13 Dec 2012 11:59:18 -0200
Message-Id: <1355407206-17100-194-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

Fix warning about unused variable introduced by commit e681b66f2e19fa
("USB: mos7840: remove invalid disconnect handling") upstream.

A subsequent fix which removed the disconnect function got rid of the
warning but that one was only backported to v3.6.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/mos7840.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 9b819c4..1b5ea51 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2676,7 +2676,6 @@ error:
 static void mos7840_disconnect(struct usb_serial *serial)
 {
 	int i;
-	unsigned long flags;
 	struct moschip_port *mos7840_port;
 
 	if (!serial) {
-- 
1.7.9.5

