Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300Ab2KZRQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:16:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48349 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934277Ab2KZRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 267/270] libceph: drop declaration of ceph_con_get()
Date: Mon, 26 Nov 2012 14:59:17 -0200
Message-Id: <1353949160-26803-268-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 261030215d970c62f799e6e508e3c68fc7ec2aa9 upstream.

For some reason the declaration of ceph_con_get() and
ceph_con_put() did not get deleted in this commit:
    d59315ca libceph: drop ceph_con_get/put helpers and nref member

Clean that up.

Signed-off-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 9844241..189ae06 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -215,8 +215,6 @@ extern void ceph_msg_revoke(struct ceph_msg *msg);
 extern void ceph_msg_revoke_incoming(struct ceph_msg *msg);
 
 extern void ceph_con_keepalive(struct ceph_connection *con);
-extern struct ceph_connection *ceph_con_get(struct ceph_connection *con);
-extern void ceph_con_put(struct ceph_connection *con);
 
 extern struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags,
 				     bool can_fail);
-- 
1.7.9.5

