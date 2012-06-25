Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2FYRpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:45:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44133 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2FYRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:45:37 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: eparis@redhat.com
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: [PATCH 0/3] audit-tree fixes
Date: Mon, 25 Jun 2012 19:46:15 +0200
Message-Id: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short series to fix refcounting in audit-tree.

Please apply.

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


