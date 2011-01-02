Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1ABHXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:35391 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1ABHXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:13 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 102/260] NFS: Fix a typo in nfs_sockaddr_match_ipaddr6
Date: Sun,  2 Jan 2011 02:16:38 -0500
Message-Id: <1293952756-15010-103-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:01.0946 (UTC) FILETIME=[BFEE4BA0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b20d37ca9561711c6a3c4b859c2855f49565e061 upstream.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/client.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index acc9c49..5f3fb75 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -274,7 +274,7 @@ static int nfs_sockaddr_match_ipaddr6(const struct sockaddr *sa1,
 	    sin1->sin6_scope_id != sin2->sin6_scope_id)
 		return 0;
 
-	return ipv6_addr_equal(&sin1->sin6_addr, &sin1->sin6_addr);
+	return ipv6_addr_equal(&sin1->sin6_addr, &sin2->sin6_addr);
 }
 #else	/* !defined(CONFIG_IPV6) && !defined(CONFIG_IPV6_MODULE) */
 static int nfs_sockaddr_match_ipaddr6(const struct sockaddr *sa1,
-- 
1.7.3.3

