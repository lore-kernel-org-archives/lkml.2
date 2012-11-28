Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2K1QoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2K1Qn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:43:58 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 01/25] mm: remove old aio use_mm() comment
Date: Wed, 28 Nov 2012 08:43:25 -0800
Message-Id: <1354121029-1376-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@redhat.com>

use_mm() is used in more places than just aio.  There's no need to
mention callers when describing the function.

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 mm/mmu_context.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index 3dcfaf4..8a8cd02 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -14,9 +14,6 @@
  * use_mm
  *	Makes the calling kernel thread take on the specified
  *	mm context.
- *	Called by the retry thread execute retries within the
- *	iocb issuer's mm context, so that copy_from/to_user
- *	operations work seamlessly for aio.
  *	(Note: this routine is intended to be called only
  *	from a kernel thread context)
  */
-- 
1.7.12

