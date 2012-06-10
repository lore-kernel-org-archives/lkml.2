Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2FJSm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 14:42:26 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2712 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab2FJSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 14:42:25 -0400
Message-ID: <1339353740.30984.46.camel@x61.thuisdomein>
Subject: [PATCH] microblaze: clinkage.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Date: Sun, 10 Jun 2012 20:42:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 10 Jun 2012 18:42:20.0995 (UTC) FILETIME=[C4D9A130:01CD4738]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing includes <asm/clinkage.h>. It has actually never been included
since it was added to the tree in commit
9981cd94d526a300dbef58048b1d281386b7289c ("microblaze_v8: clinkage.h
linkage.h sections.h kmap_types.h"). That's not surprising, since
including it is indistinguishable from including <linux/linkage.h>. It
can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only by using various git commands on the (history of the) tree.

 arch/microblaze/include/asm/clinkage.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/clinkage.h

diff --git a/arch/microblaze/include/asm/clinkage.h b/arch/microblaze/include/asm/clinkage.h
deleted file mode 100644
index 9e21843..0000000
--- a/arch/microblaze/include/asm/clinkage.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <linux/linkage.h>
-- 
1.7.7.6

