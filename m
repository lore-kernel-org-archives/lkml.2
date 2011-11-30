Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab1K3COk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:14:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52070 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3COi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:14:38 -0500
From: Joe Perches <joe@perches.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/28] fs: Logging style neatening and checkpatch wanking...
Date: Tue, 29 Nov 2011 18:13:58 -0800
Message-Id: <cover.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging styles.

Some messages now have prefixes that didn't previously.
buffer:, exec:, namespace: and a few others.

Neaten the file coding style while there.

Joe Perches (28):
  buffer: Use pr_<level>
  mbcache: Use current logging styles
  bio: Use current logging styles
  libfs: Use current logging styles
  super: Use current logging styles
  exec: Use current logging style
  namespace: Use current logging styles
  block_dev: Use current logging style
  dcache: Use current logging style
  fcntl: Use current logging style
  file: Use current logging style
  locks: Use current logging style
  open: Use current logging style
  stat: Use current logging style
  exec: checkpatch wanking
  namespace: checkpatch wanking
  block_dev: checkpatch wanking
  dcache: checkpatch wanking
  fcntl: checkpatch wanking
  file: checkpatch wanking
  locks: checkpatch wanking
  open: checkpatch wanking
  stat: checkpatch wanking
  super: checkpatch wanking
  libfs: checkpatch wanking
  bio: checkpatch wanking
  mbcache: checkpatch wanking.
  buffer: checkpatch wanking

 fs/bio.c       |   31 +++++---
 fs/block_dev.c |   81 ++++++++++-----------
 fs/buffer.c    |  143 ++++++++++++++++++-------------------
 fs/dcache.c    |  137 ++++++++++++++++++------------------
 fs/exec.c      |  106 ++++++++++++++--------------
 fs/fcntl.c     |  134 ++++++++++++++++++-----------------
 fs/file.c      |   25 ++++---
 fs/libfs.c     |  215 +++++++++++++++++++++++++++++---------------------------
 fs/locks.c     |  125 +++++++++++++++-----------------
 fs/mbcache.c   |   82 +++++++++------------
 fs/namespace.c |   61 ++++++++--------
 fs/open.c      |   41 ++++++-----
 fs/stat.c      |   33 ++++-----
 fs/super.c     |   60 ++++++---------
 14 files changed, 631 insertions(+), 643 deletions(-)

-- 
1.7.6.405.gc1be0

