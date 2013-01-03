Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3ACMVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:21:07 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:40540 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3ACMUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:32 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 26/26] remove unused random32() and srandom32()
Date: Thu,  3 Jan 2013 21:19:22 +0900
Message-Id: <1357215562-6288-27-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After finishing a naming transition, remove unused backward
compatibility wrapper macros

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---

* Change from v1
- leave net_random() and net_srandom() definision

 include/linux/random.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index d984608..2ae2840 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -29,13 +29,6 @@ u32 prandom_u32(void);
 void prandom_bytes(void *buf, int nbytes);
 void prandom_seed(u32 seed);
 
-/*
- * These macros are preserved for backward compatibility and should be
- * removed as soon as a transition is finished.
- */
-#define random32() prandom_u32()
-#define srandom32(seed) prandom_seed(seed)
-
 u32 prandom_u32_state(struct rnd_state *);
 void prandom_bytes_state(struct rnd_state *state, void *buf, int nbytes);
 
-- 
1.7.11.7

