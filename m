Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1KOOTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:19:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44513 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1KOOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:19:54 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio-mmio: Correct the name of the guest features selector
Date: Tue, 15 Nov 2011 16:17:18 +0200
Message-Id: <1321366638-28408-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guest features selector spelling mistake.

Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---

Hopefully not too late to fix, should possibly be done in one of the next RCs
since it's user facing.

 include/linux/virtio_mmio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/virtio_mmio.h b/include/linux/virtio_mmio.h
index 27c7ede..5c7b6f0 100644
--- a/include/linux/virtio_mmio.h
+++ b/include/linux/virtio_mmio.h
@@ -63,7 +63,7 @@
 #define VIRTIO_MMIO_GUEST_FEATURES	0x020
 
 /* Activated features set selector - Write Only */
-#define VIRTIO_MMIO_GUEST_FEATURES_SET	0x024
+#define VIRTIO_MMIO_GUEST_FEATURES_SEL	0x024
 
 /* Guest's memory page size in bytes - Write Only */
 #define VIRTIO_MMIO_GUEST_PAGE_SIZE	0x028
-- 
1.7.8.rc1

