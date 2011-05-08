Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab1EHWmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:42:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab1EHWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rzsU6n2x7zQ48mT+3KZo/XvqKZ2hr56Lp6ViIC34x2XrXfKvnu7d7REvzn/qUvdDZv
         7OtqYMm3/qxRgf76WD04+5OzJlsBe4GvOh9+RSWQxJl0a6fWO5XPEXYMGfh00Fy6KZOY
         RraozwhKMnZRAqTlAOsg1UjDEuZjcdDGYqsU8=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 094/115] sysctl: net/core: create empty dir with register_sysctl_dir
Date: Mon,  9 May 2011 00:39:46 +0200
Message-Id: <1304894407-32201-95-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/core/sysctl_net_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 385b609..6d2fe6e 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -239,9 +239,7 @@ static __net_initdata struct pernet_operations sysctl_core_ops = {
 
 static __init int sysctl_core_init(void)
 {
-	static struct ctl_table empty[1];
-
-	register_sysctl_paths(net_core_path, empty);
+	register_sysctl_dir(net_core_path);
 	register_net_sysctl_rotable(net_core_path, net_core_table);
 	return register_pernet_subsys(&sysctl_core_ops);
 }
-- 
1.7.5.134.g1c08b

