Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1GaNIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 09:08:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48977 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1GaNIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 09:08:10 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Lukas Czerner <lczerner@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH -mmotm] ext4: remove unused ext4_set_bit_atomic and ext4_clear_bit_atomic
Date: Sun, 31 Jul 2011 22:09:43 +0900
Message-Id: <1312117783-5985-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This depends on ext4-use-proper-little-endian-bitops.patch in -mm tree)

This removes unused macro definisions for ext4_set_bit_atomic and
ext4_clear_bit_atomic.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>
---
 fs/ext4/ext4.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e7811f7..4cf1dd8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -932,10 +932,8 @@ struct ext4_inode_info {
 
 #define ext4_test_and_set_bit		__test_and_set_bit_le
 #define ext4_set_bit			__set_bit_le
-#define ext4_set_bit_atomic		ext2_set_bit_atomic
 #define ext4_test_and_clear_bit		__test_and_clear_bit_le
 #define ext4_clear_bit			__clear_bit_le
-#define ext4_clear_bit_atomic		ext2_clear_bit_atomic
 #define ext4_test_bit			test_bit_le
 #define ext4_find_next_zero_bit		find_next_zero_bit_le
 #define ext4_find_next_bit		find_next_bit_le
-- 
1.7.4.4

