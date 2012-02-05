Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2BEA3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:29:22 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10816 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2BEA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:29:21 -0500
Date: Sun, 5 Feb 2012 01:29:47 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-btrfs@vger.kernel.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] BTRFS: Don't include disk-io.h twice in check-integrity.c
Message-ID: <alpine.LNX.2.00.1202050128450.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once should be enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/check-integrity.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index b669a7d..064b29b 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -89,7 +89,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "extent_io.h"
-#include "disk-io.h"
 #include "volumes.h"
 #include "print-tree.h"
 #include "locking.h"
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

