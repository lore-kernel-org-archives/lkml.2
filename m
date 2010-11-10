Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0KJXqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:46:30 -0500
Received: from mail.perches.com ([173.55.12.10]:4957 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540Ab0KJXq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:29 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/6] fs/udf: Add printf format/argument verification
Date: Wed, 10 Nov 2010 15:46:18 -0800
Message-Id: <1291c7cdd5f04608337644bb7f455f4286f999d9.1289432524.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__((format... to udf_warning.

All arguments matched formats, no other changes necessary.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/udfdecl.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 6995ab1..74d58c0 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -111,6 +111,8 @@ struct extent_position {
 };
 
 /* super.c */
+
+__attribute__((format(printf, 3, 4)))
 extern void udf_warning(struct super_block *, const char *, const char *, ...);
 static inline void udf_updated_lvid(struct super_block *sb)
 {
-- 
1.7.3.1.g432b3.dirty

