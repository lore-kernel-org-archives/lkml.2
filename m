Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0CSUlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:41:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63504 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0CSUlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i4ZotS+WClmUw1oixBrdD8nfSxxf7AjAmc+B/0JcLT72/CoHZW9fS2CGEcHXrZZvTt
         gVJzkEpkGRoXviWRkjDtu8Jc9lt/idKrlC8Hvec4vdUq2S6YNCVLByMU1KebCei6xAVe
         Xm+GO6iJyS1uRIPA2fCAcCbJSn36u5M6nL/JU=
From: Sankar P <sankar.curiosity@gmail.com>
To: gregkh@suse.de, pavel@ucw.cz, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sankar.curiosity@gmail.com
Subject: [PATCH 2/6] staging: winbond: Remove unused enum enum_PowerManagementMode
Date: Sat, 20 Mar 2010 02:11:00 +0530
Message-Id: <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com>
 <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
---
 drivers/staging/winbond/mac_structures.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index ad19c88..7eb0e57 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -116,13 +116,6 @@
 #define WLAN_MAX_PAIRWISE_CIPHER_SUITE_COUNT    ((u16) 6)
 #define WLAN_MAX_AUTH_KEY_MGT_SUITE_LIST_COUNT  ((u16) 2)
 
-//========================================================
-typedef enum enum_PowerManagementMode
-{
-    ACTIVE = 0,
-    POWER_SAVE
-} WB_PM_Mode, *PWB_PM_MODE;
-
 //===================================================================
 //  Reason Code (Table 18): indicate the reason of DisAssoc, DeAuthen
 //  length of ReasonCode is 2 Octs.
-- 
1.6.4.2

