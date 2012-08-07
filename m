Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab2HGXi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:38:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab2HGW2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:28:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 034/122] USB: Remove unused LPM variable.
Date: Tue,  7 Aug 2012 15:25:22 -0700
Message-Id: <20120807221951.304600886@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit c5c4bdf02e518a281b229ae0891b346919e2d291 upstream.

hub_initiated_lpm_disable_count is not used by any code, so remove it.

This commit should be backported to kernels as old as 3.5, that contain
the commit 8306095fd2c1100e8244c09bf560f97aca5a311d "USB: Disable USB
3.0 LPM in critical sections."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/usb.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -556,7 +556,6 @@ struct usb_device {
 	struct usb3_lpm_parameters u1_params;
 	struct usb3_lpm_parameters u2_params;
 	unsigned lpm_disable_count;
-	unsigned hub_initiated_lpm_disable_count;
 };
 #define	to_usb_device(d) container_of(d, struct usb_device, dev)
 


