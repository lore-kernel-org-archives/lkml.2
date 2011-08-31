Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1HaUXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:23:22 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42870 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1HaUXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:23:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: zcache - trivial tweak to build-time error message wording
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 31 Aug 2011 16:23:16 -0400
Message-ID: <54715.1314822196@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E5E9835.00D8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify that the requirement is "at least one of" - the error message could
potentially be read as both being required.

Yes, the line is over 80 chars.  You can't get 79 chars of text and a #error
into 80 chars :)

Patch against linux-next-20110831

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-next/drivers/staging/zcache/zcache-main.c.dist	2011-08-31 13:31:27.054696837 -0400
+++ linux-next/drivers/staging/zcache/zcache-main.c	2011-08-31 16:16:46.055659964 -0400
@@ -34,7 +34,7 @@
 #include "../zram/xvmalloc.h" /* if built in drivers/staging */
 
 #if (!defined(CONFIG_CLEANCACHE) && !defined(CONFIG_FRONTSWAP))
-#error "zcache is useless without CONFIG_CLEANCACHE or CONFIG_FRONTSWAP"
+#error "zcache is useless without at least one of CONFIG_CLEANCACHE or CONFIG_FRONTSWAP"
 #endif
 #ifdef CONFIG_CLEANCACHE
 #include <linux/cleancache.h>

