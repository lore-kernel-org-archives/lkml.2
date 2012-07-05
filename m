Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab2GESUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:20:18 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37061 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2GESUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:20:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 10/10] MAINTAINERS: Theodore Ts'o is taking over the random driver
Date: Thu,  5 Jul 2012 14:12:13 -0400
Message-Id: <1341511933-11169-11-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall stepped down as the /dev/random driver maintainer last
year, so Theodore Ts'o is taking back the /dev/random driver.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb22272..808cceb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3159,9 +3159,9 @@ F:	drivers/hwmon/
 F:	include/linux/hwmon*.h
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-M:	Matt Mackall <mpm@selenic.com>
+M:	Theodore Ts'o" <tytso@mit.edu>
 M:	Herbert Xu <herbert@gondor.apana.org.au>
-S:	Odd fixes
+S:	Maintained
 F:	Documentation/hw_random.txt
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
-- 
1.7.11.1.108.gb129051

