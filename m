Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2LNWak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:30:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:38796 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168Ab2LNWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:30:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 18/28] USB: mark uas driver as BROKEN
Date: Fri, 14 Dec 2012 14:26:35 -0800
Message-Id: <20121214222254.680248067@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222250.501309822@linuxfoundation.org>
References: <20121214222250.501309822@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit fb37ef98015f864d22be223a0e0d93547cd1d4ef upstream.

As reported https://bugzilla.kernel.org/show_bug.cgi?id=51031, the UAS
driver causes problems and has been asked to be not built into any of
the major distributions.  To prevent users from running into problems
with it, and for distros that were not notified, just mark the whole
thing as broken.

Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -203,7 +203,7 @@ config USB_STORAGE_ENE_UB6250
 
 config USB_UAS
 	tristate "USB Attached SCSI"
-	depends on USB && SCSI
+	depends on USB && SCSI && BROKEN
 	help
 	  The USB Attached SCSI protocol is supported by some USB
 	  storage devices.  It permits higher performance by supporting


