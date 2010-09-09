Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0IIWgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47134 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab0IIWgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OqgaYTg5hXj/UI/3mmbDMoef0UW0vdnFhH0MXRxM0lBhs2eeHJXKhEXBetL/zM5vMo
         VBCt7PJtANgT24rNPbPoflOGa0loP8yrZkMLZh+08T9wWbcEe+FRyia+OY3veIUiNF1a
         sjR9U7Xcwbb/jyaJo7GYWu28D1vtN+YWby7o8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 117/223]drivers/net/epic100.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:46 -0700
Message-Id: <1284071809-8149-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/epic100.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/epic100.c b/drivers/net/epic100.c
index 57c8ac0..b9a934b 100644
--- a/drivers/net/epic100.c
+++ b/drivers/net/epic100.c
@@ -18,8 +18,7 @@
 	Annapolis MD 21403
 
 	Information and updates available at
-	http://www.scyld.com/network/epic100.html
-	[this link no longer provides anything useful -jgarzik]
+	http://www.silan.com.cn/All/Default.aspx	
 
 	---------------------------------------------------------------------
 
@@ -131,8 +130,8 @@ IIIa. Ring buffers
 
 IVb. References
 
-http://www.smsc.com/main/tools/discontinued/83c171.pdf
-http://www.smsc.com/main/tools/discontinued/83c175.pdf
+http://www.smsc.com/media/Downloads_Public/discontinued/83c171.pdf
+http://www.smsc.com/media/Downloads_Public/discontinued/83c175.pdf
 http://scyld.com/expert/NWay.html
 http://www.national.com/pf/DP/DP83840A.html
 
-- 
1.7.2.1

