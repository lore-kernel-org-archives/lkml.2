Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763083Ab2KBRH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:07:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:33432 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab2KBRHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [ 17/24] USB: io_edgeport: remove unused variable
Date: Fri,  2 Nov 2012 10:07:05 -0700
Message-Id: <20121102170248.653597289@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

The stable commit 12ddc74e8e25107eda81aceb74e3311c1480b381
("USB: io_edgeport: fix port-data memory leak") left one variable
unused:
    drivers/usb/serial/io_edgeport.c: In function 'edge_release':
    drivers/usb/serial/io_edgeport.c:3155:6: warning: unused variable 'i' [-Wunused-variable]

Remove this unused variable.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_edgeport.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -3152,7 +3152,6 @@ static void edge_disconnect(struct usb_s
 static void edge_release(struct usb_serial *serial)
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
-	int i;
 
 	dbg("%s", __func__);
 


