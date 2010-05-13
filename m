Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0EMAG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:06:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:53889 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752702Ab0EMAGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:06:24 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18y4Y5qqm8yESgvmwSPs09rWqmQeqqlexk3jGRp28
	4J1P4rC9Rlcd9s
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] lib/atomic64_test: Fix missing include of linux/kernel.h
Date: Thu, 13 May 2010 02:06:23 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: linux-sh@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005130206.24329.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>:

This patch fixes a build-failure[1] by adding the missing include file
(linux/kernel.h) for printk and KERN_INFO.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next 20100512
References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2601239/

 lib/atomic64_test.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 65e482c..9087d71 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -9,6 +9,7 @@
  * (at your option) any later version.
  */
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <asm/atomic.h>
 
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
-- 
1.6.4.4

