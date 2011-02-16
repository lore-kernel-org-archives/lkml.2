Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1BPGzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:55:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51331 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab1BPGzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:55:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=An3sBh0nsFJN7eDNJGGXdod9Kf8RPU69mb0p0kOm6a7ElvnBsDgQJyOcwpfeRPWLRG
         kgyYeprnbPGMtEJhQfcHYuQ6Q47+0hAoTyw1GPxpS9edEhnLXf8S221yd3s/KEUSgu9R
         t5sETbLf5sj/54MW1ctjv3t4j8VY7WBduZLUM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/3]arch:cris:arch-v10i:init.c Fix typo occationally to occasionally
Date: Tue, 15 Feb 2011 22:54:44 -0800
Message-Id: <1297839284-3091-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo occationally to occasionally.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/cris/arch-v10/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v10/mm/init.c b/arch/cris/arch-v10/mm/init.c
index baa746c..e7f8066 100644
--- a/arch/cris/arch-v10/mm/init.c
+++ b/arch/cris/arch-v10/mm/init.c
@@ -241,7 +241,7 @@ flush_etrax_cacherange(void *startadr, int length)
 }
 
 /* Due to a bug in Etrax100(LX) all versions, receiving DMA buffers
- * will occationally corrupt certain CPU writes if the DMA buffers
+ * will occasionally corrupt certain CPU writes if the DMA buffers
  * happen to be hot in the cache.
  * 
  * As a workaround, we have to flush the relevant parts of the cache
-- 
1.6.5.2.180.gc5b3e

