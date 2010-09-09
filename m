Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0IIXAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:00:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab0IIWgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W+4VOSqpvIP6dd2gBTG+7qFf3qQwDNNLL2YfY4wnhdoDh7tYyMTvghoux+UwzSysR3
         vHF6zoDAf/rpvjogj784SnaosGZbHNMo+Z3jYu6AD+X+S9AD1DdiOY/cpfnO7rwi/DE/
         qVk7W7aYSDGdu+Rzu6CgHCCkzGjVaCPRJgUYo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 115/223]drivers/net/pci-skeleton.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:44 -0700
Message-Id: <1284071809-8149-10-git-send-email-justinmattock@gmail.com>
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
 drivers/net/pci-skeleton.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pci-skeleton.c b/drivers/net/pci-skeleton.c
index 56f3fc4..d654eff 100644
--- a/drivers/net/pci-skeleton.c
+++ b/drivers/net/pci-skeleton.c
@@ -78,7 +78,7 @@ that almost all frames will need to be copied to an alignment buffer.
 
 IVb. References
 
-http://www.realtek.com.tw/cn/cn.html
+http://www.realtek.com.tw/
 http://www.scyld.com/expert/NWay.html
 
 IVc. Errata
@@ -106,7 +106,7 @@ IVc. Errata
 
 static char version[] __devinitdata =
 	KERN_INFO NETDRV_DRIVER_LOAD_MSG "\n"
-	"  Support available from http://foo.com/bar/baz.html\n";
+	"  Support available from linux-wireless@vger.kernel.org\n";
 
 /* define to 1 to enable PIO instead of MMIO */
 #undef USE_IO_OPS
-- 
1.7.2.1

