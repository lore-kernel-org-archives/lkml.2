Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab0IBVIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:08:40 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab0IBVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BMBvG2FZWMKd12S6XHuKt9LmCn0h9KgdRO0T7I0xScKu4s9MBORuQeWGByQzPs7oES
         4JKyLodrQx3X4imWcbzvf5jhb5UHFnhpZilAxUVaLVeI+qI9BZ69lApuDUUeeMGeUaMT
         WumtdtRMg7nV/oRTy/+75puAHp2TmMD09hsgM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 29/91] arch/ia64/lib/idiv32.S Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:58 -0700
Message-Id: <1283461679-7851-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/lib/idiv32.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/lib/idiv32.S b/arch/ia64/lib/idiv32.S
index 2ac28bf..dad1949 100644
--- a/arch/ia64/lib/idiv32.S
+++ b/arch/ia64/lib/idiv32.S
@@ -7,7 +7,8 @@
  * This code is based on the application note entitled "Divide, Square Root
  * and Remainder Algorithms for the IA-64 Architecture".  This document
  * is available as Intel document number 248725-002 or via the web at
- * http://developer.intel.com/software/opensource/numerics/
+ * http://web.archive.org/web/20020611073250/developer.intel.com/
+ * software/products/opensource/libraries/num.htm 
  *
  * For more details on the theory behind these algorithms, see "IA-64
  * and Elementary Functions" by Peter Markstein; HP Professional Books
-- 
1.7.2.1

