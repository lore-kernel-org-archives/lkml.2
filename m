Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117Ab1CXUTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51040 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab1CXUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=q4fbejUyZAAysa8PLNh+Jk8zpgaEo/2FsLX7+RvWX3/0CbLadxwcifzOztTRe9Dr5s
         3o6qA7oYWlOyX4W0ZGcko5y5ojKb3YBX8AulWRSKtWq6igqACHyR7wXmEzkZoYuctQ8Q
         c80CQuNY062tKpT6mhDVST/i0ev4t+a9wu/wE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 03/21]arch:um:drivers:mmapper_kern.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:22 -0700
Message-Id: <1300997920-31573-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
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

