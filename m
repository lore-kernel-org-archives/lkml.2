Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0CSUlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:41:39 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63504 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0CSUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ye6QxoGKR3XE6q/xfStoScRhhhFXCnFkJP+ucpQOxOuXF3arEx9pl8NYNN81C6WinT
         09BpPadsBObGmEf1lmjf9AAsQGGjp0RRbnEVQmu59YF0S4dgc+QrA/2HYWuw9a+jGhHm
         TIUsZRsNKyoR27YBrCcDR6eSrZo/l3rheY6QE=
From: Sankar P <sankar.curiosity@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sankar.curiosity@gmail.com
Subject: [PATCH 1/6] staging: winbond: Convert typedef struct _PMKID to struct pmkid
Date: Sat, 20 Mar 2010 02:10:59 +0530
Message-Id: <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the definition typedef struct _PMKID to
struct pmkid and also the part where the typedef was used.

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 drivers/staging/winbond/mac_structures.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 0d16196..ad19c88 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -505,10 +505,10 @@ struct RSN_Capability_Element
 }__attribute__ ((packed)) ;
 
 #ifdef _WPA2_
-typedef struct _PMKID
+struct pmkid
 {
   u8 pValue[16];
-}PMKID;
+};
 
 struct	WPA2_RSN_Information_Element
 {
@@ -531,7 +531,7 @@ struct WPA2_RSN_Auth_Sub_Information_Element
 struct PMKID_Information_Element
 {
 	u16				PMKID_Count;
-	PMKID pmkid [16] ;
+	struct pmkid pmkid[16];
 }__attribute__ ((packed));
 
 #endif //enddef _WPA2_
-- 
1.6.4.2

