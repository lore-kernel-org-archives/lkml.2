Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2GMIyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab2GMIyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:54:16 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH RESEND 2/5] eventfd: Export symbol eventfd_file_create()
Date: Fri, 13 Jul 2012 16:55:08 +0800
Message-Id: <1342169711-12386-3-git-send-email-asias@redhat.com>
In-Reply-To: <1342169711-12386-1-git-send-email-asias@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for people who want to create an eventfd in kernel,
e.g. vhost-blk.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
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

