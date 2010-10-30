Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0J3VNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:13:36 -0400
Received: from mail.perches.com ([173.55.12.10]:3766 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab0J3VJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:39 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/39] drivers/staging: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:38 -0700
Message-Id: <8312f0d8caf92953b08390be149a9c0ac49ad516.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/memrar/memrar_allocator.c    |    2 +-
 drivers/staging/solo6x10/solo6010-v4l2-enc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/memrar/memrar_allocator.c b/drivers/staging/memrar/memrar_allocator.c
index a4f8c58..705bde8 100644
--- a/drivers/staging/memrar/memrar_allocator.c
+++ b/drivers/staging/memrar/memrar_allocator.c
@@ -74,7 +74,7 @@ struct memrar_allocator *memrar_create_allocator(unsigned long base,
 	 * and issue a diagnostic.
 	 */
 	WARN(capacity < block_size * 2,
-	     "memrar: Only one block available to allocator.\n");
+	     "memrar: Only one block available to allocator\n");
 
 	allocator = kmalloc(sizeof(*allocator), GFP_KERNEL);
 
diff --git a/drivers/staging/solo6x10/solo6010-v4l2-enc.c b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
index bbf3d9c..f73567d 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2-enc.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
@@ -184,7 +184,7 @@ static void solo_update_mode(struct solo_enc_dev *solo_enc)
 		solo_enc->bw_weight <<= 2;
 		break;
 	default:
-		WARN(1, "mode is unknown");
+		WARN(1, "mode is unknown\n");
 	}
 }
 
-- 
1.7.3.1.g432b3.dirty

