Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0JYNeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:34:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61735 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0JYNeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=satSbPQblJQ8RmDZxt+LfP26yFSQ6NS3phuip/PoAsojRmeNA5uDXybY2BLq06Nk8j
         QRYloRwKfEJ0xdyIYWhT3k0P1WSYckFHwI8r4GnnfiRdG26M3I4p3nnd52gHVGkY+4bp
         bs+6uT5BskH7Grt78Ud2m/CN43f6OjcqJYR3o=
Subject: [PATCH] mm/rmap.c: fix comment
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 21:32:52 +0800
Message-ID: <1288013572.3108.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up comment. 

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
mm/rmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 92e6757..479540d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -94,7 +94,7 @@ void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
  * anonymous pages mapped into it with that anon_vma.
  *
  * The common case will be that we already have one, but if
- * if not we either need to find an adjacent mapping that we
+ * not we either need to find an adjacent mapping that we
  * can re-use the anon_vma from (very common when the only
  * reason for splitting a vma has been mprotect()), or we
  * allocate a new one.


