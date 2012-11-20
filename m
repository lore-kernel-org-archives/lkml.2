Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2KTOpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:34 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58222 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2KTOpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:30 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 5/8] staging: wlags49_h2: wl_if.h: fixes brace placement
Date: Tue, 20 Nov 2012 16:44:57 +0200
Message-Id: <1353422700-14485-4-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
References: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes incorrect brace placement, as reported by the
checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_if.h |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_if.h b/drivers/staging/wlags49_h2/wl_if.h
index 61193b3..351d29b 100644
--- a/drivers/staging/wlags49_h2/wl_if.h
+++ b/drivers/staging/wlags49_h2/wl_if.h
@@ -175,20 +175,17 @@ UIL_FUN_PUT_INFO
 /*******************************************************************************
  * STRUCTURE DEFINITIONS
  ******************************************************************************/
-typedef struct
-{
+typedef struct {
 	__u16   length;
 	__u8    name[HCF_MAX_NAME_LEN];
 }
 wvName_t;
 
 
-typedef struct
-{
+typedef struct {
 	hcf_16      len;
 	hcf_16      typ;
-	union
-	{
+	union {
 		hcf_8       u8[MAX_LTV_BUF_SIZE / sizeof(hcf_8)];
 		hcf_16      u16[MAX_LTV_BUF_SIZE / sizeof(hcf_16)];
 		hcf_32      u32[MAX_LTV_BUF_SIZE / sizeof(hcf_32)];
@@ -197,10 +194,8 @@ typedef struct
 ltv_t;
 
 
-struct uilreq
-{
-	union
-	{
+struct uilreq {
+	union {
 		char    ifrn_name[IFNAMSIZ];
 	} ifr_ifrn;
 
@@ -216,10 +211,8 @@ struct uilreq
 };
 
 
-struct rtsreq
-{
-	union
-	{
+struct rtsreq {
+	union {
 		char    ifrn_name[IFNAMSIZ];
 	}
 	ifr_ifrn;
-- 
1.7.10.4

