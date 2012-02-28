Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966032Ab2B1TFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:05:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51728 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964824Ab2B1TFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:05:21 -0500
Message-ID: <1330455920.21481.3.camel@joe2Laptop>
Subject: [PATCH] MAINTAINERS: Add status to ALPHA architecture
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 11:05:20 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing S: status line to ALPHA.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c9759ca..2a8a260 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -464,6 +464,7 @@ ALPHA PORT
 M:	Richard Henderson <rth@twiddle.net>
 M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
 M:	Matt Turner <mattst88@gmail.com>
+S:	Odd Fixes
 L:	linux-alpha@vger.kernel.org
 F:	arch/alpha/
 


