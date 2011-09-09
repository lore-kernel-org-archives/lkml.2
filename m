Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab1IIScE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:32:04 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:37662 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab1IIScB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:32:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1315593090!285945!56
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/sha1.c: quite sparse noise about symbol not declared
Date: Fri, 9 Sep 2011 11:30:27 -0700
User-Agent: KMail/1.9.9
CC: <msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091130.28110.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include <linux/cryptohash.h> to pickup the declarations for sha_transform
and sha_init to quite the sparse noise:

warning: symbol 'sha_transform' was not declared. Should it be static?
warning: symbol 'sha_init' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Mandeep Singh Baines <msb@chromium.org>

---

diff --git a/lib/sha1.c b/lib/sha1.c
index f33271d..1de509a 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/cryptohash.h>
 #include <asm/unaligned.h>
 
 /*
