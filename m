Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2F1K5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:57:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2F1K5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:57:42 -0400
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH 1/7] memcg: update cgroup memory document
Date: Thu, 28 Jun 2012 18:57:35 +0800
Message-Id: <1340881055-5511-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

Document cgroup dirty/writeback memory statistics.

The implementation for these new interface routines come in a series
of following patches.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 Documentation/cgroups/memory.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index dd88540..24d7e3c 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -420,6 +420,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
+dirty		- # of bytes that are waiting to get written back to the disk.
+writeback	- # of bytes that are actively being written back to the disk.
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-- 
1.7.1

