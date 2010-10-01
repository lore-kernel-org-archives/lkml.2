Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0JARdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:33:13 -0400
Received: from mail.tpi.com ([70.99.223.143]:1040 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0JARdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:33:12 -0400
Message-ID: <4CA61B50.6090203@canonical.com>
Date: Fri, 01 Oct 2010 11:33:04 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: feng.tang@intel.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial/mfd.c: Fix ARM compile error
Content-Type: multipart/mixed;
 boundary="------------020700000808060100020008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020700000808060100020008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Does it even make sense to build this module for non-x86 architectures?

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------020700000808060100020008
Content-Type: text/x-patch;
 name="0001-UBUNTU-Upstream-Fix-ARM-compile-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-UBUNTU-Upstream-Fix-ARM-compile-error.patch"

>From 61cdfbb1040ca0809c2f4988aa90297c185a6b22 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Fri, 1 Oct 2010 11:24:41 -0600
Subject: [PATCH] serial/mfd.c: Fix ARM compile error

drivers/serial/mfd.c: In function 'port_show_regs':
drivers/serial/mfd.c:144: error: implicit declaration of function 'kzalloc'

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/serial/mfd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
index 324c385..b67f499 100644
--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <linux/debugfs.h>
 
 #define  MFD_HSU_A0_STEPPING	1
-- 
1.7.0.4


--------------020700000808060100020008--
