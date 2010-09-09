Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0IIXL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:11:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38003 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab0IIWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ahiQrg7t+Z+Rl5Xi6cfINVWb8o8NfkohVSyRDC6lfeL5IvQEP+mNUQRN2Q7o2WRX3+
         jDQx/JQ3vm6Qq0HSseAklXD4DSkoozowYAZFIc5YaUknhGz+kGrV9JvybbYmrKep+ChD
         J79uW0H7h0oih6Kj05M+1fGQMq9IQVO2k/lQE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 006/223]drivers/char/tpm/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:42 -0700
Message-Id: <1284071091-7676-7-git-send-email-justinmattock@gmail.com>
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
 drivers/char/tpm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 4dc338f..f6595ab 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -58,6 +58,6 @@ config TCG_INFINEON
 	  To compile this driver as a module, choose M here; the module
 	  will be called tpm_infineon.
 	  Further information on this driver and the supported hardware
-	  can be found at http://www.prosec.rub.de/tpm
+	  can be found at http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/ 
 
 endif # TCG_TPM
-- 
1.7.2.1

