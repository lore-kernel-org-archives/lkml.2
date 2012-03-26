Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2CZKyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:54:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49166 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2CZKyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:54:09 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 0/6] vfs: path lookup fixes and cleanups
Date: Mon, 26 Mar 2012 12:54:18 +0200
Message-Id: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remaining fixes and cleanups before the atomic open series that stand on their
own.

Please apply.

Thanks,
Miklos

---
Miklos Szeredi (6):
      vfs: fix d_need_lookup/d_revalidate order in do_lookup
      vfs: don't revalidate just looked up dentry
      vfs: move MAY_EXEC check from __lookup_hash()
      vfs: set LOOKUP_JUMPED in follow_managed
      vfs: reorganize do_lookup
      vfs: split __lookup_hash

---
 fs/namei.c |  219 +++++++++++++++++++++++++-----------------------------------
 1 files changed, 90 insertions(+), 129 deletions(-)

