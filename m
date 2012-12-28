Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2L1Th3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:37:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55406 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255Ab2L1TS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:56 -0500
Message-Id: <20121228190347.984970195@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 085/173] USB: mark uas driver as BROKEN
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg KH <gregkh@linuxfoundation.org>

commit fb37ef98015f864d22be223a0e0d93547cd1d4ef upstream.

As reported https://bugzilla.kernel.org/show_bug.cgi?id=51031, the UAS
driver causes problems and has been asked to be not built into any of
the major distributions.  To prevent users from running into problems
with it, and for distros that were not notified, just mark the whole
thing as broken.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 0ae7bb6..eab04a6 100644
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


