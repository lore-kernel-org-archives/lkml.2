Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab1BPCNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:13:52 -0500
Received: from kroah.org ([198.145.64.141]:48718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab1BPBtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:55 2011
Message-Id: <20110216014655.201064188@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Richard=20Sch=C3=BCtz?= <r.schtz@t-online.de>
Subject: [009/115] USB: usb-storage: unusual_devs update for Cypress ATACB
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Schütz <r.schtz@t-online.de>

commit cae41118f50ef0c431e13159df6d7dd8bbd54004 upstream.

New device ID added for unusual Cypress ATACB device.

Signed-off-by: Richard Schütz <r.schtz@t-online.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_cypress.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,4 +31,9 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x
 		"Cypress ISD-300LP",
 		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
 
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
+		"Super Top",
+		"USB 2.0  SATA BRIDGE",
+		US_SC_CYP_ATACB, US_PR_DEVICE, NULL, 0),
+
 #endif /* defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || ... */


