Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0IIW3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:29:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44570 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab0IIW33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N5kYs+4/spnnZSeIfEuEemYm3mYJrfeJb7H0hqXw+HLCJdkpr26RlOMEQ+vE23qmoE
         N2643OO7PaIXk/RPb/Hul8fu3q6ix4Ato+EgvtCo2zV2K4BHFwMqUGJePev2WvXa1Ggl
         yhmCa0EbU57pBI6Z5lVr3c7J4/+UoDLKFQ/ZA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 084/223]drivers/mtd/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:28 -0700
Message-Id: <1284071374-7867-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
References: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/mtd/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 1e2cbf5..6f08a26 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -292,9 +292,9 @@ config RFD_FTL
 	---help---
 	  This provides support for the flash translation layer known
 	  as the Resident Flash Disk (RFD), as used by the Embedded BIOS
-	  of General Software. There is a blurb at:
+	  of General Software. 
 
-		http://www.gensw.com/pages/prod/bios/rfd.htm
+		http://www.phoenix.com/	
 
 config SSFDC
 	tristate "NAND SSFDC (SmartMedia) read only translation layer"
-- 
1.7.2.1

