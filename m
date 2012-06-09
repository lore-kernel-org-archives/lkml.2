Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2FIUJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 16:09:04 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3633 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab2FIUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 16:09:01 -0400
Message-ID: <1339272539.30984.21.camel@x61.thuisdomein>
Subject: [PATCH] parisc: remove unused and empty header
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 09 Jun 2012 22:08:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 09 Jun 2012 20:08:59.0707 (UTC) FILETIME=[B51C60B0:01CD467B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing includes real.h. That's unsurprising, since it's basically
empty. This has apparently been the case since (at least) v2.6.12-rc2.
It can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only by prodding at the (history of the) tree with various git commands.

 arch/parisc/include/asm/real.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)
 delete mode 100644 arch/parisc/include/asm/real.h

diff --git a/arch/parisc/include/asm/real.h b/arch/parisc/include/asm/real.h
deleted file mode 100644
index 82acb25..0000000
--- a/arch/parisc/include/asm/real.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#ifndef _PARISC_REAL_H
-#define _PARISC_REAL_H
-
-
-#endif
-- 
1.7.7.6

