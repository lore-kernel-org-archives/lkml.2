Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2HUTEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:04:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56615 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2HUTEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:04:02 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Cc: eparis@redhat.com, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 0/3] audit-tree fixes
Date: Tue, 21 Aug 2012 21:03:56 +0200
Message-Id: <1345575839-9389-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The audit subsystem maintainers (Al and Eric) are not responding to repeated
resends.  Eric did ack them a while ago, but no response since then.  So I'm
sending these directly to you.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git audit-fixes

Thanks,
Miklos


---
Miklos Szeredi (3):
      audit: don't free_chunk() after fsnotify_add_mark()
      audit: fix refcounting in audit-tree
      audit: clean up refcounting in audit-tree

---
 kernel/audit_tree.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

