Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1A1EFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:23 -0500
Received: from mail.perches.com ([173.55.12.10]:3465 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab1A1EE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:56 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] staging: ath6kl: Convert tspecCompliance from A_BOOL to int
Date: Thu, 27 Jan 2011 20:04:32 -0800
Message-Id: <2ec8e8ac49534dc9becfbda43125812ff96f8317.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the use in wmi_verify_tspec_params match the declaration
of the variable.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/include/wmi_api.h |    2 +-
 drivers/staging/ath6kl/wmi/wmi.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/include/wmi_api.h b/drivers/staging/ath6kl/include/wmi_api.h
index 5207a19..0d7d0cc 100644
--- a/drivers/staging/ath6kl/include/wmi_api.h
+++ b/drivers/staging/ath6kl/include/wmi_api.h
@@ -234,7 +234,7 @@ int wmi_set_voice_pkt_size_cmd(struct wmi_t *wmip, A_UINT16 voicePktSize);
 int wmi_set_max_sp_len_cmd(struct wmi_t *wmip, A_UINT8 maxSpLen);
 A_UINT8  convert_userPriority_to_trafficClass(A_UINT8 userPriority);
 A_UINT8 wmi_get_power_mode_cmd(struct wmi_t *wmip);
-int wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, A_BOOL tspecCompliance);
+int wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, int tspecCompliance);
 
 #ifdef CONFIG_HOST_TCMD_SUPPORT
 int wmi_test_cmd(struct wmi_t *wmip, A_UINT8 *buf, A_UINT32  len);
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index b6c9905..c384bb2 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -4650,7 +4650,7 @@ wmi_get_power_mode_cmd(struct wmi_t *wmip)
 }
 
 int
-wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, A_BOOL tspecCompliance)
+wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, int tspecCompliance)
 {
     int ret = A_OK;
 
-- 
1.7.4.rc3

