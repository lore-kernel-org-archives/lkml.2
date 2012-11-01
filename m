Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab2KAFx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab2KAFxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:53:52 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: maxk@qti.qualcomm.com, edumazet@google.com, krkumar2@in.ibm.com,
        ernesto.martin@viasat.com, haixiao@juniper.net,
        Jason Wang <jasowang@redhat.com>
Subject: [net-next v5 1/7] tuntap: log the unsigned informaiton with %u
Date: Thu,  1 Nov 2012 13:45:56 +0800
Message-Id: <1351748762-3455-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1351748762-3455-1-git-send-email-jasowang@redhat.com>
References: <1351748762-3455-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3157519..f830b1b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1419,7 +1419,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	if (!tun)
 		goto unlock;
 
-	tun_debug(KERN_INFO, tun, "tun_chr_ioctl cmd %d\n", cmd);
+	tun_debug(KERN_INFO, tun, "tun_chr_ioctl cmd %u\n", cmd);
 
 	ret = 0;
 	switch (cmd) {
@@ -1459,7 +1459,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			break;
 		}
 		tun->owner = owner;
-		tun_debug(KERN_INFO, tun, "owner set to %d\n",
+		tun_debug(KERN_INFO, tun, "owner set to %u\n",
 			  from_kuid(&init_user_ns, tun->owner));
 		break;
 
@@ -1471,7 +1471,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			break;
 		}
 		tun->group = group;
-		tun_debug(KERN_INFO, tun, "group set to %d\n",
+		tun_debug(KERN_INFO, tun, "group set to %u\n",
 			  from_kgid(&init_user_ns, tun->group));
 		break;
 
-- 
1.7.1

