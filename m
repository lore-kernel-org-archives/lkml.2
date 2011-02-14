Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1BNXM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:12:26 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60420 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1BNXMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:12:23 -0500
Subject: [PATCH] [TRIVIAL] fix comment typo uninitized
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 15 Feb 2011 00:05:43 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297724835.1793.37.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6b90b68..1b3d188 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2844,7 +2844,7 @@ fix_extent_len:
  * ext4_get_blocks_dio_write() when DIO to write
  * to an uninitialized extent.
  *
- * Writing to an uninitized extent may result in splitting the uninitialized
+ * Writing to an uninitialized extent may result in splitting the uninitialized
  * extent into multiple /initialized uninitialized extents (up to three)
  * There are three possibilities:
  *   a> There is no split required: Entire extent should be uninitialized
-- 
1.7.4



