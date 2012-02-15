Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2BOT1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:27:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab2BOT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:27:13 -0500
Subject: [PATCH] memcg: kill dead prev_priority stubs
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Feb 2012 23:27:08 +0400
Message-ID: <20120215192708.31690.2819.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was removed in v2.6.35-5854-g25edde0
("vmscan: kill prev_priority completely")

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/memcontrol.h |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 453a3dd..c697eda 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -296,21 +296,6 @@ static inline void mem_cgroup_iter_break(struct mem_cgroup *root,
 {
 }
 
-static inline int mem_cgroup_get_reclaim_priority(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
-static inline void mem_cgroup_note_reclaim_priority(struct mem_cgroup *memcg,
-						int priority)
-{
-}
-
-static inline void mem_cgroup_record_reclaim_priority(struct mem_cgroup *memcg,
-						int priority)
-{
-}
-
 static inline bool mem_cgroup_disabled(void)
 {
 	return true;

