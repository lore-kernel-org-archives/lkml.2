Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0HZSfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:35:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58029 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0HZSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:35:16 -0400
Message-Id: <20100826183340.027591901@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 20:33:40 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
Subject: [PATCH 0/5] hybrid union filesystem prototype
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the result of my experimentation with trying to do
union-mounts like semantics with a filesystem.  The implementation is
far from perfect, but I think the concept does sort of work.  See the
patch header for the union filesystem.

VFS modifications necessary to make it work:

  - allow f_op->open() to return a different file
  - pass dentry to i_op->permission() instead of inode
  - hack to vfs_rename() to allow rename to same inode

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git union-hybrid

Thanks,
Miklos
-- 
