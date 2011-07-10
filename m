Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1GJV0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 17:26:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61485 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1GJV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 17:26:40 -0400
From: raghu.prabhu13@gmail.com
To: akpm@linux-foundation.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com
Cc: keithp@keithp.com, viro@zeniv.linux.org.uk, riel@redhat.com,
        swhiteho@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: [PATCH] Remove incorrect usage of sysctl_vfs_cache_pressure
Date: Mon, 11 Jul 2011 02:56:23 +0530
Message-Id: <cover.1310331583.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

In shrinker functions, sysctl_vfs_cache_pressure variable is being used while
trimming slab caches in general and not restricted to inode/dentry caches as
documented for that sysctl.

Raghavendra D Prabhu (1):
  mm/vmscan: Remove sysctl_vfs_cache_pressure from non-vfs shrinkers

 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 fs/gfs2/glock.c                 |    2 +-
 fs/gfs2/quota.c                 |    2 +-
 fs/mbcache.c                    |    2 +-
 fs/nfs/dir.c                    |    2 +-
 fs/quota/dquot.c                |    3 +--
 net/sunrpc/auth.c               |    2 +-
 7 files changed, 7 insertions(+), 8 deletions(-)

-- 
1.7.6

