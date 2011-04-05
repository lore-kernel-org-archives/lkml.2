Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1DEPBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:44470 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab1DEO7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:38 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 26/34] dlm: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:13 +0200
Message-Id: <1302015561-21047-27-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/dlm/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/main.c b/fs/dlm/main.c
index b80e0aa..5a59efa 100644
--- a/fs/dlm/main.c
+++ b/fs/dlm/main.c
@@ -50,7 +50,7 @@ static int __init init_dlm(void)
 	if (error)
 		goto out_netlink;
 
-	printk("DLM (built %s %s) installed\n", __DATE__, __TIME__);
+	printk("DLM installed\n");
 
 	return 0;
 
-- 
1.7.4.1

