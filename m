Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab0IIWpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:45:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46296 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab0IIWpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dEm/pZsaXDC0BgZum+3Tz0taLpkaq2rsbPGACMVx6CzidtvQH91IMxXTzpaI7yt162
         /OlNDvNEbOi1Qs+7/V60Nt5SCEmGOkW+4VcIwq/9srl8r0WZcPcTNUwchKZYEii3aOq7
         M++6ouhRQPUirO12i8YT/h8gZ9V3yXIaX5/4k=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 210/223]drivers/usb/storage/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:45:09 -0700
Message-Id: <1284072309-8452-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
References: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/storage/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 8a372ba..b356e15 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -36,7 +36,7 @@ config USB_STORAGE_DATAFAB
 	depends on USB_STORAGE
 	help
 	  Support for certain Datafab CompactFlash readers.
-	  Datafab has a web page at <http://www.datafabusa.com/>.
+	  Datafab has a web page at <http://www.datafab.com/>.
 
 	  If this driver is compiled as a module, it will be named ums-datafab.
 
-- 
1.7.2.1

