Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab2AUSE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:56 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:37239 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751539Ab2AUSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:53 -0500
Message-ID: <4F1B0BF8.1080105@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 13/14] docbook: change iomap source filename in deviceiobook
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix warning since kernel-doc comments were moved to another
source file.

Warning(lib/iomap.c): no structured comments found

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/DocBook/deviceiobook.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-33-rc1.orig/Documentation/DocBook/deviceiobook.tmpl
+++ lnx-33-rc1/Documentation/DocBook/deviceiobook.tmpl
@@ -317,7 +317,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
 !Iarch/x86/include/asm/io.h
-!Elib/iomap.c
+!Elib/pci_iomap.c
   </chapter>
 
 </book>
