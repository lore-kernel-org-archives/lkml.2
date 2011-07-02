Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab1GBGir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 02:38:47 -0400
Received: from mail.perches.com ([173.55.12.10]:3495 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab1GBGiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 02:38:46 -0400
Subject: [PATCH] MAINTAINERS: Orphan FrameRelay DLCI
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 23:38:43 -0700
Message-ID: <1309588723.18925.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike McLagan hasn't contributed in many years
and his email bounces.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c1d8b98..d1b88a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2626,9 +2626,8 @@ S:	Maintained
 F:	arch/x86/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
-M:	Mike McLagan <mike.mclagan@linux.org>
 L:	netdev@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 


