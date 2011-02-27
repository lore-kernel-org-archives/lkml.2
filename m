Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1B0Ee7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:34:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1B0Eez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HF5bu6F4vFYcSgeI9TQhDFIg/6Ut4QfEPVNgQ9X2vDZabCuSgnH3ObHBt2Jqba+nOw
         kIM5jNRYUnnqyFT97QxMfdOcPTq67UV2KAq2BSFUaQ8juJdsfJC6HFGgv1aOQ81i8wQs
         nLqeY8S7DD4LrUg9iWZ8eF28C5plFqKRglCEU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 15/17]mm:mempolicy.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:08 -0800
Message-Id: <1298781250-2718-16-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org
---
 mm/mempolicy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 368fc9d..a5d7995 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -993,7 +993,7 @@ int do_migrate_pages(struct mm_struct *mm,
 	 * most recent <s, d> pair that moved (s != d).  If we find a pair
 	 * that not only moved, but what's better, moved to an empty slot
 	 * (d is not set in tmp), then we break out then, with that pair.
-	 * Otherwise when we finish scannng from_tmp, we at least have the
+	 * Otherwise when we finish scanning from_tmp, we at least have the
 	 * most recent <s, d> pair that moved.  If we get all the way through
 	 * the scan of tmp without finding any node that moved, much less
 	 * moved to an empty node, then there is nothing left worth migrating.
-- 
1.7.4.1

