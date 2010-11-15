Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0KODFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:32 -0500
Received: from mail.perches.com ([173.55.12.10]:1127 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab0KODF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:29 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/44] arch/microblaze: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:21 -0800
Message-Id: <5d57b90b488b4338bcdc3f0fbf5f6996842bd44d.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/microblaze/lib/memmove.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
index 123e361..810fd68 100644
--- a/arch/microblaze/lib/memmove.c
+++ b/arch/microblaze/lib/memmove.c
@@ -182,7 +182,7 @@ void *memmove(void *v_dst, const void *v_src, __kernel_size_t c)
 			for (; c >= 4; c -= 4) {
 				value = *--i_src;
 				*--i_dst = buf_hold | ((value & 0xFF000000)>> 24);
-				buf_hold = (value & 0xFFFFFF) << 8;;
+				buf_hold = (value & 0xFFFFFF) << 8;
 			}
 #endif
 			/* Realign the source */
-- 
1.7.3.1.g432b3.dirty

