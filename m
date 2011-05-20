Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935033Ab1ETANM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:13:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56162 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935021Ab1ETAMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:23 -0400
X-Sasl-enc: zrMmjTqYdV1hfjqYJfgeVsaVOdMJVzcHETVYxuo9KvRe 1305850342
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/44] drivers/base/memory.c: fix warning due to "memory hotplug: Speed up add/remove when blocks are larger than PAGES_PER_SECTION"
Date: Thu, 19 May 2011 17:11:00 -0700
Message-Id: <1305850262-9575-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

drivers/base/memory.c: In function 'memory_block_change_state':
drivers/base/memory.c:281: warning: unused variable 'i'

less beer, more testing

Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index c4c443d..0a134a4 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -278,7 +278,7 @@ memory_block_action(unsigned long phys_index, unsigned long action)
 static int memory_block_change_state(struct memory_block *mem,
 		unsigned long to_state, unsigned long from_state_req)
 {
-	int i, ret = 0;
+	int ret = 0;
 
 	mutex_lock(&mem->state_mutex);
 
-- 
1.7.4.2

