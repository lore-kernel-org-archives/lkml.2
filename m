Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab0CaA3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:29:12 -0400
Received: from kroah.org ([198.145.64.141]:48897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab0C3XMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:19 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:27 2010
Message-Id: <20100330225826.949240584@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       David Vrabel <david.vrabel@csr.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [30/89] USB: add speed values for USB 3.0 and wireless controllers
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit b132b04e193908a94d95065d0628f8fb0159cc55 upstream.

These controllers say "unknown" for their speed in sysfs, which
obviously isn't correct.

Reported-by: Kurt Garloff <garloff@novell.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/sysfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -111,6 +111,12 @@ show_speed(struct device *dev, struct de
 	case USB_SPEED_HIGH:
 		speed = "480";
 		break;
+	case USB_SPEED_VARIABLE:
+		speed = "480";
+		break;
+	case USB_SPEED_SUPER:
+		speed = "5000";
+		break;
 	default:
 		speed = "unknown";
 	}


