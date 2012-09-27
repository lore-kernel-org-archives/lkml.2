Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2I0MTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:19:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42441 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2I0MTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:19:13 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Misc vfs code clean
Date: Thu, 27 Sep 2012 20:16:08 +0800
Message-Id: <1348748176-3726-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Hong (8):
  fs/namespace.c: introduce helper function path_unmounted()
  fs/namespace.c: remove unused macro MNT_WRITER_UNDERFLOW_LIMIT
  fs/namespace.c: trivial code clean
  fs/namespace.c: check permission early in sys_[u]mount
  fs/namei.c: introduce macro AT_FDINV
  fs/inode.c: call alloc_inode() in new_inode() directly
  fs/inode.c: remove outstanding spin lock prefetch
  vfs: misc comment clean

 fs/dcache.c           |   11 ++++-----
 fs/inode.c            |   13 +++++------
 fs/namei.c            |   13 ++++++-----
 fs/namespace.c        |   59 ++++++++++++++++++++-----------------------------
 include/linux/fcntl.h |    2 ++
 5 files changed, 43 insertions(+), 55 deletions(-)

-- 
1.7.9.5

