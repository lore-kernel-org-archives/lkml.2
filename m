Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1FYWqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:46:52 -0400
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:51263 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048Ab1FYWqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:46:51 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jun 2011 18:46:51 EDT
Message-ID: <4E06633F.9010307@svenskalinuxforeningen.se>
Date: Sun, 26 Jun 2011 00:37:51 +0200
From: =?ISO-8859-1?Q?Torbj=F6rn_Svensson?= 
	<azoff@svenskalinuxforeningen.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110505 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, Trivial Patch Monkey <trivial@kernel.org>
Subject: [PATCH] Corrected a small typo in help text for CONFIG_CLEANCACHE
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.252.185.168
X-Scan-Result: No virus found in message 1QabUK-0007qL-HE.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1QabUK-0007qL-HE d3cfec9c63399303f9ad76e4d05242f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected a small typo in the help text for CONFIG_CLEANCACHE.

Signed-of-by: Torbjörn Svensson <azoff@svenskalinuxforeningen.se>
---
 mm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 8ca47a5..f2f1ca1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -356,7 +356,7 @@ config CLEANCACHE
 	  for clean pages that the kernel's pageframe replacement algorithm
 	  (PFRA) would like to keep around, but can't since there isn't enough
 	  memory.  So when the PFRA "evicts" a page, it first attempts to use
-	  cleancacne code to put the data contained in that page into
+	  cleancache code to put the data contained in that page into
 	  "transcendent memory", memory that is not directly accessible or
 	  addressable by the kernel and is of unknown and possibly
 	  time-varying size.  And when a cleancache-enabled

