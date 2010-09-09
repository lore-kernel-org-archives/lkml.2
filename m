Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0IIWYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:24:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35469 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab0IIWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C02Lr2wr/tYSXyCQ39ZfHBYUf19wnlkzuS7AdlLvvXaDQop0E2vnUnbsmSeQYhKqs1
         QfvwM4RIH6xjokuad5LeSxPJccV5ZiUmIbc4y/VUtiuFtiMKfqdPZgT42OJZ5TXk8z18
         pV7YBhF7qWsCe6J/NFtgqsPNLNUFwxJASnePc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 003/223]drivers/block/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:39 -0700
Message-Id: <1284071091-7676-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/block/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index de27768..645a3f8 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -169,7 +169,7 @@ config BLK_DEV_UMEM
 	---help---
 	  Saying Y here will include support for the MM5415 family of
 	  battery backed (Non-volatile) RAM cards.
-	  <http://www.umem.com/>
+	  <http://web.archive.org/web/*/http://www.umem.com/>
 
 	  The cards appear as block devices that can be partitioned into
 	  as many as 15 partitions.
-- 
1.7.2.1

