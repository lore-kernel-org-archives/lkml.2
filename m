Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0IIWZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:25:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39116 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab0IIWZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U2/3hd4Aa2Q3eoOf4NPBRuKFDj2h46cHsem79XSGN5OqcpT7lo0k5pSOhVRyytTl++
         9MZZbQXhUufvfmf8fyHRGhcvI4b7KRHA7JAa7SshzwH6NU3y66QUV5n/lk2F/nwAZCL+
         VzccYdGwEK6TRv04p8BYztwsoeolF/W5M3zhk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 017/223]drivers/firmware/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:25:36 -0700
Message-Id: <1284071149-7723-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
References: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/firmware/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 280c9b5..de0aca5 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -74,7 +74,7 @@ config EFI_PCDP
 
 	  You must also enable the appropriate drivers (serial, VGA, etc.)
 
-	  See <http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
+	  See <http://www.dig64.org/specifications/agreement>
 
 config DELL_RBU
 	tristate "BIOS update support for DELL systems via sysfs"
-- 
1.7.2.1

