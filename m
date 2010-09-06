Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0IFOgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:36:14 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33502 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0IFOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:36:03 -0400
Date: Mon, 6 Sep 2010 16:36:00 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 02/14] arch/h8300: Removing dead ifdef __H8300_TLB_H__
Message-ID: <c085d587a5fe2ae05ab431c746b96a0abb9fa876.1283782700.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested __H8300_TLB_H__ include guard isn't necessary at this point,
because the symbol is always defined at this point and the block
content will always be removed.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/h8300/include/asm/tlb.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/h8300/include/asm/tlb.h b/arch/h8300/include/asm/tlb.h
index 3dea80a..6339a02 100644
--- a/arch/h8300/include/asm/tlb.h
+++ b/arch/h8300/include/asm/tlb.h
@@ -7,17 +7,4 @@
 
 #define tlb_flush(tlb)	do { } while(0)
 
-/* 
-  include/asm-h8300/tlb.h 
-*/
-
-#ifndef __H8300_TLB_H__
-#define __H8300_TLB_H__
-
-#define tlb_flush(tlb)	do { } while(0)
-
-#include <asm-generic/tlb.h>
-
-#endif
-
 #endif
-- 
1.7.0.4

