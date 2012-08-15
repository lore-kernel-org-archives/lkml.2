Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2HON6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:58:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50700 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2HON6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:58:43 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjones@redhat.com, steveamigauk@yahoo.co.uk, mszeredi@suse.cz
Subject: [PATCH 0/4] vfs: fix file creation mode bugs
Date: Wed, 15 Aug 2012 15:59:55 +0200
Message-Id: <1345039199-5904-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a FUSE regression reported against 3.6-rc1 as well as an older bug
(stable CC-d).

Please apply.

Thanks,
Miklos


---
Miklos Szeredi (4):
      vfs: canonicalize create mode in build_open_flags()
      vfs: atomic_open(): fix create mode usage
      vfs: pass right create mode to may_o_create()
      fuse: check create mode in atomic open

---
 fs/fuse/dir.c |    3 +++
 fs/namei.c    |    4 ++--
 fs/open.c     |    7 ++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

