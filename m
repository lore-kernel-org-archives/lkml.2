Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab0EZQWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:22:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64924 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab0EZQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=erqPALuzBIuIjeEdlnPnuXPDNqqUVDV1ShKh9roStmPqr2hjd3/CtyDZ5viZAxvaxF
         WT2P3dK3AUZZUZHL5s0gKsjt26lCdC5fsua2PG3W7RuoluWZX4lAVJ+chF9ReCatd1OD
         Xc+O8CUakE/iEKYxRjA4ubzlPVkiYzNfNfDd4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Typo in netdevice.h
Date: Wed, 26 May 2010 09:22:40 -0700
Message-Id: <1274890960-7416-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing "of" in comment.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/netdevice.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a1bff65..c761c90 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -775,7 +775,7 @@ struct net_device {
 	/*
 	 * This is the first field of the "visible" part of this structure
 	 * (i.e. as seen by users in the "Space.c" file).  It is the name
-	 * the interface.
+	 * of the interface.
 	 */
 	char			name[IFNAMSIZ];
 
-- 
1.7.1.rc1.21.gf3bd6

