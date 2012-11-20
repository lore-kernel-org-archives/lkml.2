Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2KTOpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:15 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36327 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2KTOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:11 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 2/8] staging: wlags49_h2: wl_if.h: fixes tab indentation
Date: Tue, 20 Nov 2012 16:44:54 +0200
Message-Id: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out the tab & space indentation problems that were
reported by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_if.h |   70 ++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_if.h b/drivers/staging/wlags49_h2/wl_if.h
index d070e47..5c6b2b5 100644
--- a/drivers/staging/wlags49_h2/wl_if.h
+++ b/drivers/staging/wlags49_h2/wl_if.h
@@ -71,7 +71,7 @@
 #define MAX_LTV_BUF_SIZE            (512 - (sizeof(hcf_16) * 2))
 
 #define HCF_TALLIES_SIZE            (sizeof(CFG_HERMES_TALLIES_STRCT) + \
-                                     (sizeof(hcf_16) * 2))
+				    (sizeof(hcf_16) * 2))
 
 #define HCF_MAX_MULTICAST           16
 #define HCF_MAX_NAME_LEN            32
@@ -176,57 +176,57 @@ UIL_FUN_PUT_INFO
  ******************************************************************************/
 typedef struct
 {
-    __u16   length;
-    __u8    name[HCF_MAX_NAME_LEN];
+	__u16   length;
+	__u8    name[HCF_MAX_NAME_LEN];
 }
 wvName_t;
 
 
 typedef struct
 {
-    hcf_16      len;
-    hcf_16      typ;
-    union
-    {
-        hcf_8       u8[MAX_LTV_BUF_SIZE / sizeof(hcf_8)];
-        hcf_16      u16[MAX_LTV_BUF_SIZE / sizeof(hcf_16)];
-        hcf_32      u32[MAX_LTV_BUF_SIZE / sizeof(hcf_32)];
-    } u;
+	hcf_16      len;
+	hcf_16      typ;
+	union
+	{
+		hcf_8       u8[MAX_LTV_BUF_SIZE / sizeof(hcf_8)];
+		hcf_16      u16[MAX_LTV_BUF_SIZE / sizeof(hcf_16)];
+		hcf_32      u32[MAX_LTV_BUF_SIZE / sizeof(hcf_32)];
+	} u;
 }
 ltv_t;
 
 
 struct uilreq
 {
-    union
-    {
-        char    ifrn_name[IFNAMSIZ];
-    } ifr_ifrn;
-
-    IFBP        hcfCtx;
-    __u8        command;
-    __u8        result;
-
-    /* The data field in this structure is typically an LTV of some type. The
-       len field is the size of the buffer in bytes, as opposed to words (like
-       the L-field in the LTV */
-    __u16       len;
-    void       *data;
+	union
+	{
+		char    ifrn_name[IFNAMSIZ];
+	} ifr_ifrn;
+
+	IFBP        hcfCtx;
+	__u8        command;
+	__u8        result;
+
+	/* The data field in this structure is typically an LTV of some type. The
+	   len field is the size of the buffer in bytes, as opposed to words (like
+	   the L-field in the LTV */
+	__u16       len;
+	void       *data;
 };
 
 
 struct rtsreq
 {
-    union
-    {
-        char    ifrn_name[IFNAMSIZ];
-    }
-    ifr_ifrn;
-
-    __u16   typ;
-    __u16   reg;
-    __u16   len;
-    __u16   *data;
+	union
+	{
+		char    ifrn_name[IFNAMSIZ];
+	}
+	ifr_ifrn;
+
+	__u16   typ;
+	__u16   reg;
+	__u16   len;
+	__u16   *data;
 };
 
 
-- 
1.7.10.4

