Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1EHWn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:43:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab1EHWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KzrpCF6mVo02ALPgahVFkP3SUhtJt/yAT0PqWbt7NYkqYerP5hVQBxCPkRG0PdA57P
         LguEDKd1G/pkmiGU4MoloGUTZvEg8O31hWohagvff2RzouuofTF6lxzMXFBZ6GiCZsV0
         xvNMgstUoW4JjMMW+YXk+K8sKTawc1VDWywso=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 096/115] sysctl: net/ipv6/neigh: create empty dir with register_sysctl_dir
Date: Mon,  9 May 2011 00:39:48 +0200
Message-Id: <1304894407-32201-97-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv6/sysctl_net_ipv6.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 1d2d8c7..bb57ab4 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -15,8 +15,6 @@
 #include <net/addrconf.h>
 #include <net/inet_frag.h>
 
-static struct ctl_table empty[1];
-
 static ctl_table ipv6_bindv6only_template[] = {
 	{
 		.procname	= "bindv6only",
@@ -173,7 +171,7 @@ static struct ctl_table_header *ip6_base;
 
 int ipv6_static_sysctl_register(void)
 {
-	ip6_base = register_sysctl_paths(net_ipv6_neigh_path, empty);
+	ip6_base = register_sysctl_dir(net_ipv6_neigh_path);
 	if (ip6_base == NULL)
 		return -ENOMEM;
 	return 0;
-- 
1.7.5.134.g1c08b

