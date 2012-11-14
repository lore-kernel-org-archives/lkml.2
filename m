Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2KNGHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:07:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54946 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360Ab2KNFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:01 -0500
Message-Id: <20121114053935.803593195@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 14/82] USB: mos7840: remove unused variable
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

Fix warning about unused variable introduced by commit e681b66f2e19fa
("USB: mos7840: remove invalid disconnect handling") upstream.

A subsequent fix which removed the disconnect function got rid of the
warning but that one was only backported to v3.6.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
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



