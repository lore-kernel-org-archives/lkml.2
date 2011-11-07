Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab1KGDUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 22:20:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63019 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1KGDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 22:20:16 -0500
Message-ID: <1320636009.10415.2.camel@phoenix>
Subject: [PATCH 2/2] mfd: include linux/module.h for ab5500-debugfs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 07 Nov 2011 11:20:09 +0800
In-Reply-To: <1320635954.10415.1.camel@phoenix>
References: <1320635954.10415.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/module.h to fix below build error:

  CC      drivers/mfd/ab5500-debugfs.o
drivers/mfd/ab5500-debugfs.c:571: error: 'THIS_MODULE' undeclared here (not in a function)
make[2]: *** [drivers/mfd/ab5500-debugfs.o] Error 1

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/ab5500-debugfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab5500-debugfs.c b/drivers/mfd/ab5500-debugfs.c
index 6be1fe6..b7b2d348 100644
--- a/drivers/mfd/ab5500-debugfs.c
+++ b/drivers/mfd/ab5500-debugfs.c
@@ -4,6 +4,7 @@
  * Debugfs support for the AB5500 MFD driver
  */
 
+#include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/mfd/ab5500/ab5500.h>
-- 
1.7.5.4



