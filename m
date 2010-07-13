Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0GMJuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:50:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59944 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0GMJuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=ZbRx1KVZwYf2O68cJMOMOaPZfYrOTygV0JwqdSUJjwGs2rkkoN5QUPknmHMrbS+Rok
         NB2rDbT7GiUYX6ZhoNyTLG7qWrMXsQyQwNM6J6gIos8/PairLl6TNuwzl4KhE7EP7vnv
         WuPYNAvBpdFIO00wYdEVPBlLpzG4MRNC8OwR0=
Subject: [PATCH RESEND reiserfs] trivial typo fix
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, trivial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 05:50:12 -0400
Message-ID: <1279014612.18280.1.camel@cowboy>
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




