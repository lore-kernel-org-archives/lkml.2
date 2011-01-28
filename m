Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1A1EFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:15 -0500
Received: from mail.perches.com ([173.55.12.10]:3444 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab1A1EEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:54 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] staging: ath6kl: Convert A_BOOL compressed sets from 0 to FALSE
Date: Thu, 27 Jan 2011 20:04:26 -0800
Message-Id: <625400b6c57b9439066f8cbb45eae803a50c0d86.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the appropriate define.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 3ad3d57..01ebdf1 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1034,7 +1034,7 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, A_UINT32 address, A
                         ar->arVersion.target_ver));
                     return A_ERROR;
                 }
-                compressed = 0;
+                compressed = FALSE;
             }
             
 #ifdef CONFIG_HOST_TCMD_SUPPORT
@@ -1047,7 +1047,7 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, A_UINT32 address, A
                     AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
                     return A_ERROR;
                 }
-                compressed = 0;
+                compressed = FALSE;
             }
 #endif 
 #ifdef HTC_RAW_INTERFACE
@@ -1060,7 +1060,7 @@ ar6000_transfer_bin_file(AR_SOFTC_T *ar, AR6K_BIN_FILE file, A_UINT32 address, A
                     AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Unknown firmware revision: %d\n", ar->arVersion.target_ver));
                     return A_ERROR;
                 }
-                compressed = 0;                
+                compressed = FALSE;
             }
 #endif 
             break;
-- 
1.7.4.rc3

