Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab1CXT1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:27:25 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63376 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab1CXT1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tWAKpzTNTpCeHRUQizr63CX8vQutJu7Gg2EGExRNQoN2KYIrB+zXytyYjs8WagXkDO
         BbDD3XJ8WsIXb9Eb5v98hMMFqvfzUTidTGUqRW8Fmvt196gLpJdq+6rTnJuGF4o2AeEw
         tBPZrRVxMk3Lfw1yokxyDz1otws81FNVYoBdY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 03/21]arch:um:drivers:mmapper_kern.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:41 -0700
Message-Id: <1300994819-30930-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/um/drivers/mmapper_kern.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index 7e0619c..c0ef803 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
@@ -116,7 +116,7 @@ static int __init mmapper_init(void)
 	if (err) {
 		printk(KERN_ERR "mmapper - misc_register failed, err = %d\n",
 		       err);
-		return err;;
+		return err;
 	}
 	return 0;
 }
-- 
1.7.4.1

