Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2LGWWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:22:09 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45196 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2LGWWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:22:06 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] fs/ecryptfs/crypto.c: make ecryptfs_encode_for_filename() static
Date: Fri,  7 Dec 2012 22:21:56 +0000
Message-Id: <1354918916-31587-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the function ecryptfs_encode_for_filename() is only used in this file

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/ecryptfs/crypto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index ea99312..a7b0c2d 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1935,7 +1935,7 @@ static const unsigned char filename_rev_map[256] = {
  * @src: Source location for the filename to encode
  * @src_size: Size of the source in bytes
  */
-void ecryptfs_encode_for_filename(unsigned char *dst, size_t *dst_size,
+static void ecryptfs_encode_for_filename(unsigned char *dst, size_t *dst_size,
 				  unsigned char *src, size_t src_size)
 {
 	size_t num_blocks;
-- 
1.7.4.5

