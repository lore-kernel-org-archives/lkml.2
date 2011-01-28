Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1A1EFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:12 -0500
Received: from mail.perches.com ([173.55.12.10]:3442 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab1A1EEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:53 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] staging: ath6kl: Convert type of streamExists to A_UINT8
Date: Thu, 27 Jan 2011 20:04:24 -0800
Message-Id: <ae2af73461ec882c8b305a0dfeb1638c78d72244.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the declaration type match the assigned from type.
It's not a bool, it's a u8.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/wmi/wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 73cf866..b6c9905 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -537,7 +537,7 @@ A_UINT8 wmi_implicit_create_pstream(struct wmi_t *wmip, void *osbuf, A_UINT32 la
     A_UINT8         trafficClass = WMM_AC_BE;
     A_UINT16        ipType = IP_ETHERTYPE;
     WMI_DATA_HDR    *dtHdr;
-    A_BOOL           streamExists = FALSE;
+    A_UINT8           streamExists = 0;
     A_UINT8        userPriority;
     A_UINT32            hdrsize, metasize;
     ATH_LLC_SNAP_HDR    *llcHdr;
-- 
1.7.4.rc3

