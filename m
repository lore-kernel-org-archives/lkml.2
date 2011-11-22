Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1KVF7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:59:15 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45591 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab1KVF7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:59:13 -0500
Message-ID: <1321941549.27077.17.camel@edumazet-laptop>
Subject: [PATCH] slub: fix slub_max_order Documentation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 06:59:09 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slub_max_order default is 3 (aka PAGE_ALLOC_COSTLY_ORDER), not 1

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 Documentation/vm/slub.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
index f464f47..2acdda9 100644
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -117,7 +117,7 @@ can be influenced by kernel parameters:
 
 slub_min_objects=x		(default 4)
 slub_min_order=x		(default 0)
-slub_max_order=x		(default 1)
+slub_max_order=x		(default 3 (PAGE_ALLOC_COSTLY_ORDER))
 
 slub_min_objects allows to specify how many objects must at least fit
 into one slab in order for the allocation order to be acceptable.


