Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1B0EhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:37:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40844 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1B0Eei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y8BLGPYyfzLF6Le7m9Osf8Kb5ck/HvCSk6vXNJLkc19Cg+i1sHKdBKHgtPByZdAkat
         4NHnXVX5a3VBiC814O7hZIyNyiF+fUi4bEw8HwmVSgWwbjgnj7NYlwmxj5aAI7Z+Gpa5
         hmJaGuBdE4kH8xpoHgWHf3OPOxqEPOGZ6ASjQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 05/17]drivers:staging:brcm80211:include:bcmsdh_sdmmc.h Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:33:58 -0800
Message-Id: <1298781250-2718-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: not sure if I sent this out or not.

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Brett Rudley <brudley@broadcom.com>
CC: Henry Ptasinski <henryp@broadcom.com>
CC: linux-wireless@vger.kernel.org 
---
 drivers/staging/brcm80211/include/bcmsdh_sdmmc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/include/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/include/bcmsdh_sdmmc.h
index 4d671dd..c9602c6 100644
--- a/drivers/staging/brcm80211/include/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/include/bcmsdh_sdmmc.h
@@ -52,7 +52,7 @@ extern void sdioh_sdmmc_osfree(sdioh_info_t *sd);
 
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
-	bool client_intr_enabled;	/* interrupt connnected flag */
+	bool client_intr_enabled;	/* interrupt connected flag */
 	bool intr_handler_valid;	/* client driver interrupt handler valid */
 	sdioh_cb_fn_t intr_handler;	/* registered interrupt handler */
 	void *intr_handler_arg;	/* argument to call interrupt handler */
-- 
1.7.4.1

