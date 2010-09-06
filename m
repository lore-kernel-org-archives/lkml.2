Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0IFAvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:50945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab0IFAvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:13 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:27 +1000
Subject: [PATCH 00/10] Assorted fixes/enhancements for overlayfs
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,
 following are an assortment of suggested changes for overlayfs for
 your consideration.
 They pass some light testing.

Thanks,
NeilBrown


---

NeilBrown (10):
      ovl: small optimisation for ovl_lookup
      ovl: minimal remount support.
      ovl: use correct seek function for directories.
      ovl: initialise is_real before use.
      ovl: make sure fsync is never called on the lower filesystem.
      ovl: rename ovl_fill_cache to ovl_dir_read
      ovl: add initial revalidate support
      VFS: tiny optimisation in open_other handling.
      VFS: Remove read-only checks from dentry_permission
      ovl: Assorted updates to Documentation/filesystems/overlayfs.txt


 Documentation/filesystems/overlayfs.txt |   41 ++++---
 fs/namei.c                              |   15 ---
 fs/open.c                               |    2 
 fs/overlayfs/overlayfs.c                |  186 ++++++++++++++++++++++---------
 4 files changed, 152 insertions(+), 92 deletions(-)

-- 
Signature

