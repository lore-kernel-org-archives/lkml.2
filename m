Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1EHWn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:43:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab1EHWmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uMw00PIah9OrYLJsj0UMPFnlfTE/s0E5KbFkMv9EPif6las85qvxm3m/VDuytQn9M/
         qLIzQanFygerbM6cf1E11woNqCFEq3jTSZn2z5eXswKGTkZjQo8V9yu3FBiwTLi+586D
         KsWfJM86vqjPdgIZCIlM7QHbewPkCZxXLE830=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 095/115] sysctl: net/ipv4/neigh: create empty dir with register_sysctl_dir
Date: Mon,  9 May 2011 00:39:47 +0200
Message-Id: <1304894407-32201-96-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv4/route.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 46c7b3d..092f3d1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3151,8 +3151,6 @@ static ctl_table ipv4_route_table[] = {
 	{ }
 };
 
-static struct ctl_table empty[1];
-
 static __net_initdata struct ctl_path ipv4_neigh_path[] = {
 	{ .procname = "net", },
 	{ .procname = "ipv4", },
@@ -3310,6 +3308,6 @@ int __init ip_rt_init(void)
 void __init ip_static_sysctl_init(void)
 {
 	register_sysctl_paths(ipv4_route_path, ipv4_route_table);
-	register_sysctl_paths(ipv4_neigh_path, empty);
+	register_sysctl_dir(ipv4_neigh_path);
 }
 #endif
-- 
1.7.5.134.g1c08b

