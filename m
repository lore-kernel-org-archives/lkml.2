Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1DEPB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab1DEO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:36 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel@redhat.com
Subject: [PATCH 27/34] gfs2: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:14 +0200
Message-Id: <1302015561-21047-28-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/gfs2/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 72c31a3..07d057b 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -143,7 +143,7 @@ static int __init init_gfs2_fs(void)
 
 	gfs2_register_debugfs();
 
-	printk("GFS2 (built %s %s) installed\n", __DATE__, __TIME__);
+	printk("GFS2 installed\n");
 
 	return 0;
 
-- 
1.7.4.1

