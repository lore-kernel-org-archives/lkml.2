Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab0IIW3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:29:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36303 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab0IIW3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P1bO7PV3xKQmDneIhvuleaKwEAxW5VjICqVFmc4pX2tHdCDb/iL3weBjPh726utuun
         OBAF/EZLLYi+/5zGsLCLyfKDqgBJ7I9stxy0jiGsiekDRh1IHB/Rk4hVocqAZHmqBTtq
         6JTCmmVX70JKjpnJkHvj6ZiBatKSLP2XeRjEg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 087/223]drivers/net/lne390.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:31 -0700
Message-Id: <1284071374-7867-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
References: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/lne390.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/lne390.c b/drivers/net/lne390.c
index 8a1097c..a154ca4 100644
--- a/drivers/net/lne390.c
+++ b/drivers/net/lne390.c
@@ -23,8 +23,8 @@
 	The shared memory address selection is also slightly different.
 	Note that shared memory address > 1MB are supported with this driver.
 
-	You can try <http://www.mylex.com> if you want more info, as I've
-	never even seen one of these cards.  :)
+	You can try <http://web.archive.org/web/*/http://www.mylex.com>
+	if you want more info, as I've never even seen one of these cards.  :)
 
 	Arnaldo Carvalho de Melo <acme@conectiva.com.br> - 2000/09/01
 	- get rid of check_region
-- 
1.7.2.1

