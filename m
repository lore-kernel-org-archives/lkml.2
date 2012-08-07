Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2HGMoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:44:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42649 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2HGMoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:44:32 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjones@redhat.com, steveamigauk@yahoo.co.uk, mszeredi@suse.cz
Subject: [PATCH 0/4] vfs: fix file creation mode bugs
Date: Tue,  7 Aug 2012 14:45:45 +0200
Message-Id: <1344343549-11887-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Please consider the following patches.

The first one fixes an old bug (stable CC-d).  The others are fixes for the
atomic-open series.

Thanks,
Miklos
----

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

