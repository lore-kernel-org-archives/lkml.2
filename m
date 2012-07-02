Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2GBO3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:29:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab2GBO3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:29:31 -0400
Message-Id: <20120702142925.795007114@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 Jul 2012 10:29:25 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, aris@redhat.com, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: [PATCH v3 0/3] cgroup: add xattr support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series are a refreshed version of a patchset submitted by Li Zefan back
in march:
	https://lkml.org/lkml/2012/3/1/13

With Li's permission, I refreshed the patches to apply over the latest upstream
and added the modifications suggested by others in the thread:
- using a mount option instead of config option to enable the xattr support
- reinitialize the list in kmem_xattrs_free()
- renamed functions to simple_xattr_*()

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

 fs/xattr.c               |  178 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cgroup.h   |   16 +++-
 include/linux/shmem_fs.h |    3 
 include/linux/xattr.h    |   24 ++++++
 kernel/cgroup.c          |  167 +++++++++++++++++++++++++++++++++++++-------
 mm/shmem.c               |  153 +++-------------------------------------
 6 files changed, 375 insertions(+), 166 deletions(-)

-- 
Aristeu
