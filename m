Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864Ab1LGQYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:24:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844Ab1LGQX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:20 2011
Message-Id: <20111207161220.871037891@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:16 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Qinglin Ye <yestyle@gmail.com>
Subject: [074/104] USB: usb-storage: unusual_devs entry for Kingston DT 101 G2
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qinglin Ye <yestyle@gmail.com>

commit cec28a5428793b6bc64e56687fb239759d6da74e upstream.

Kingston DT 101 G2 replies a wrong tag while transporting, add an
unusal_devs entry to ignore the tag validation.

Signed-off-by: Qinglin Ye <yestyle@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1854,6 +1854,13 @@ UNUSUAL_DEV(  0x1370, 0x6828, 0x0110, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Qinglin Ye <yestyle@gmail.com> */
+UNUSUAL_DEV(  0x13fe, 0x3600, 0x0100, 0x0100,
+		"Kingston",
+		"DT 101 G2",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG ),
+
 /* Reported by Francesco Foresti <frafore@tiscali.it> */
 UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x0201,
 		"Super Top",


