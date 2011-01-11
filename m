Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1AKMPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:15:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40497 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab1AKMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V55mBYQRsglfhD05SHgqeYumccskQmdXh1ZOeFofwxDC08rYNjdkBFoCp5MXiUQgSB
         LsVkG8P0s+0R7xASW6WORD/3pXHgyQSaAHP1twqZ7aFU8ITFfk8wzGfsXx3WWjm0oS8Z
         ryX9JD61chSx1hEUAsNk0rZUtMwKD9zePiYD8=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH 1/2] dio: fix typos in comments
Date: Tue, 11 Jan 2011 21:15:03 +0900
Message-Id: <1294748104-7866-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>
---
 fs/direct-io.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6ba5f7..8201c2558d85 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -641,11 +641,11 @@ static int dio_send_cur_page(struct dio *dio)
 		/*
 		 * See whether this new request is contiguous with the old.
 		 *
-		 * Btrfs cannot handl having logically non-contiguous requests
-		 * submitted.  For exmple if you have
+		 * Btrfs cannot handle having logically non-contiguous requests
+		 * submitted.  For example if you have
 		 *
 		 * Logical:  [0-4095][HOLE][8192-12287]
-		 * Phyiscal: [0-4095]      [4096-8181]
+		 * Physical: [0-4095]      [4096-8191]
 		 *
 		 * We cannot submit those pages together as one BIO.  So if our
 		 * current logical offset in the file does not equal what would
-- 
1.7.3.4.600.g982838b0

