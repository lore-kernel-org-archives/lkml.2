Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0GFFmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 01:42:04 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:52212 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751684Ab0GFFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 01:42:03 -0400
Subject: [PATCH reiserfs] trivial typo fix
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, trivial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 01:41:57 -0400
Message-ID: <1278394917.30082.13.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix trivial typo in code comment (change adn for and), also change comment style for proper coding style.

Thanks,
Davidlohr

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 include/linux/reiserfs_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 3b603f4..ba39416 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -360,7 +360,7 @@ int is_reiserfs_jr(struct reiserfs_super_block *rs);
 /* the spot for the super in versions 3.5 - 3.5.10 (inclusive) */
 #define REISERFS_OLD_DISK_OFFSET_IN_BYTES (8 * 1024)
 
-// reiserfs internal error code (used by search_by_key adn fix_nodes))
+/* reiserfs internal error code (used by search_by_key and fix_nodes)) */
 #define CARRY_ON      0
 #define REPEAT_SEARCH -1
 #define IO_ERROR      -2
-- 
1.7.0.4



