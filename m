Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1KCIWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 04:22:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45361 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KCIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 04:22:15 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio-balloon: Trivial cleanups
Date: Thu,  3 Nov 2011 10:20:04 +0200
Message-Id: <1320308404-28859-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial changes to remove forgotten junk, format comments, and correct names.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/virtio/virtio_balloon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e058ace..289e998 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1,4 +1,5 @@
-/* Virtio balloon implementation, inspired by Dor Loar and Marcelo
+/*
+ * Virtio balloon implementation, inspired by Dor Laor and Marcelo
  * Tosatti's implementations.
  *
  *  Copyright 2008 Rusty Russell IBM Corporation
@@ -17,7 +18,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-//#define DEBUG
+
 #include <linux/virtio.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
@@ -148,7 +149,6 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 		vb->num_pages--;
 	}
 
-
 	/*
 	 * Note that if
 	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
-- 
1.7.7.1

