Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CTXjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 19:39:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35862 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1CTXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 19:39:49 -0400
From: Pawel Osciak <pawel@osciak.com>
To: linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, akpm@linux-foundation.org,
        Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] MAINTAINERS: Add videobuf2 maintainers
Date: Sun, 20 Mar 2011 16:39:39 -0700
Message-Id: <1300664379-25360-1-git-send-email-pawel@osciak.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add maintainers for the videobuf2 V4L2 driver framework.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c7a41b1..a5be079 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6665,6 +6665,14 @@ S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
 
+VIDEOBUF2 FRAMEWORK
+M:	Pawel Osciak <pawel@osciak.com>
+M:	Marek Szyprowski <m.szyprowski@samsung.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/video/videobuf2-*
+F:	include/media/videobuf2-*
+
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
 L:	virtualization@lists.linux-foundation.org
-- 
1.7.4.1

