Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0IIWYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:24:54 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35469 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab0IIWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eMb67SjL6UK9HrfzYFpEDMMQWdfYlsMO4nz6f6iE6d0ncHWSFhlzXJck2fCBuM18nC
         0Kb/1V5SMMC/JYVspyOgu8New2hqxGfbA/z/geCNXQC/PhfHp8ppHOUgVTzv9YUF+4eh
         K7K1quMtsMMXis3KDpDEs/iP8XU8zlIZBBD+0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 010/223]drivers/char/pcmcia/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:46 -0700
Message-Id: <1284071091-7676-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/pcmcia/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index ffa0efc..6614416 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -28,7 +28,7 @@ config CARDMAN_4000
 
 	  This kernel driver requires additional userspace support, either
 	  by the vendor-provided PC/SC ifd_handler (http://www.omnikey.com/),
-	  or via the cm4000 backend of OpenCT (http://www.opensc.com/).
+	  or via the cm4000 backend of OpenCT (http://www.opensc-project.org/opensc).
 
 config CARDMAN_4040
 	tristate "Omnikey CardMan 4040 support"
@@ -41,7 +41,7 @@ config CARDMAN_4040
 	  in I/O space.  To use the kernel driver, you will need either the
 	  PC/SC ifdhandler provided from the Omnikey homepage
 	  (http://www.omnikey.com/), or a current development version of OpenCT
-	  (http://www.opensc.org/).
+	  (http://www.opensc-project.org/opensc).
 
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
-- 
1.7.2.1

