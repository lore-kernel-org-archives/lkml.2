Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422756Ab2E0BRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:17:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422742Ab2E0BRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:17:47 -0400
Message-Id: <20120527002516.591644273@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:51 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Jesse Feddema <jdfeddema@gmail.com>
Subject: [ 45/91] usb-storage: unusual_devs entry for Yarvik PMP400 MP4 player
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit df767b71e5816692134d59c0c17e0f77cd73333d upstream.

This patch (as1553) adds an unusual_dev entrie for the Yarvik PMP400
MP4 music player.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Jesse Feddema <jdfeddema@gmail.com>
Tested-by: Jesse Feddema <jdfeddema@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1885,6 +1885,13 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* Reported by Jesse Feddema <jdfeddema@gmail.com> */
+UNUSUAL_DEV(  0x177f, 0x0400, 0x0000, 0x0000,
+		"Yarvik",
+		"PMP400",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
+
 /* Reported by Hans de Goede <hdegoede@redhat.com>
  * These Appotech controllers are found in Picture Frames, they provide a
  * (buggy) emulation of a cdrom drive which contains the windows software


