Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767625Ab2KOEO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:14:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:50159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767553Ab2KOENU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Johan Hovold <jhovold@gmail.com>
Subject: [ 56/57] USB: mos7840: remove unused variable
Date: Wed, 14 Nov 2012 20:12:04 -0800
Message-Id: <20121115040936.551697208@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

Fix warning about unused variable introduced by commit e681b66f2e19fa
("USB: mos7840: remove invalid disconnect handling") upstream.

A subsequent fix which removed the disconnect function got rid of the
warning but that one was only backported to v3.6.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2581,7 +2581,6 @@ error:
 static void mos7840_disconnect(struct usb_serial *serial)
 {
 	int i;
-	unsigned long flags;
 	struct moschip_port *mos7840_port;
 	dbg("%s", " disconnect :entering..........");
 


