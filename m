Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab2E1Doy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:44:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52055 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874Ab2E1D3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:31 -0400
Message-Id: <20120528031209.929225604@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Jesse Feddema <jdfeddema@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 051/117] usb-storage: unusual_devs entry for Yarvik PMP400 MP4 player
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit df767b71e5816692134d59c0c17e0f77cd73333d upstream.

This patch (as1553) adds an unusual_dev entrie for the Yarvik PMP400
MP4 music player.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Jesse Feddema <jdfeddema@gmail.com>
Tested-by: Jesse Feddema <jdfeddema@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 856ad92..8f3cbb8 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1885,6 +1885,13 @@ UNUSUAL_DEV(  0x1652, 0x6600, 0x0201, 0x0201,
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


