Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab2DMWwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:52:35 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:14288 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2DMWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:52:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1334357548!3162569!13
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation: remove 'linux' from dontdiff file
Date: Fri, 13 Apr 2012 15:52:02 -0700
User-Agent: KMail/1.9.9
CC: <linux-doc@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204131552.03079.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux entry in the dontdiff file causes the include/linux
directory to be skipped.
    
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Randy Dunlap <rdunlap@xenotime.net>

---

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index b4a898f..a25f35a 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -153,7 +153,6 @@ kxgettext
 lkc_defs.h
 lex.c
 lex.*.c
-linux
 logo_*.c
 logo_*_clut224.c
 logo_*_mono.c
