Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161230Ab2GLPk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934034Ab2GLPkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:40:24 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-fsdevel@vger.kernel.org,
        Asias He <asias@redhat.com>
Subject: [PATCH 2/5] eventfd: Export symbol eventfd_file_create()
Date: Thu, 12 Jul 2012 23:42:05 +0800
Message-Id: <1342107725-28325-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for people who want to create an eventfd in kernel,
e.g. vhost-blk.

Signed-off-by: Asias He <asias@redhat.com>
---
 fs/eventfd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index d81b9f6..b288963 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -402,6 +402,7 @@ struct file *eventfd_file_create(unsigned int count, int flags)
 
 	return file;
 }
+EXPORT_SYMBOL_GPL(eventfd_file_create);
 
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
-- 
1.7.10.4

