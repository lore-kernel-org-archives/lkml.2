Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2KHR3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:29:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42465 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KHR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:29:01 -0500
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 18:28:59 +0100
Message-ID: <CAMgPeKUTpA+qn3TA+4xpRa4z_Y1E+6mk+_Xdom+ugdqCttL3aQ@mail.gmail.com>
Subject: [PATCH] USB: mos7840: remove unused variable
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        Johan Hovold <jhovold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning about unused variable introduced by commit e681b66f2e19fa
("USB: mos7840: remove invalid disconnect handling") upstream.

A subsequent fix which removed the disconnect function got rid of the
warning but that one was only backported to v3.6.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

This patch against v3.4 also applies to v3.0 (and v3.2).

Thanks,
Johan

 drivers/usb/serial/mos7840.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 0179d34..c854235 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2581,7 +2581,6 @@ error:
 static void mos7840_disconnect(struct usb_serial *serial)
 {
 	int i;
-	unsigned long flags;
 	struct moschip_port *mos7840_port;
 	dbg("%s", " disconnect :entering..........");

-- 
1.7.12
