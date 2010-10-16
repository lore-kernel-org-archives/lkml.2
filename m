Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0JPN1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:27:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab0JPN1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ksjXwDkAoNAryDvBOnFoPyyNuBP662NzfC72NdKB5igojVH/6CE7C9CpbJqJfj03PW
         ajqZOqeYNf3SjefayKkNuOAYxyD0eN7pF5/FDI2xB0udud8+GkBx1h/sHmiw05RiL++W
         ioaw5S7eHPM9gRbPUjMrONoPNPRY5itcOt9dg=
From: Tracey Dent <tdent48227@gmail.com>
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Cc: mhw@wittsend.com, minyard@acm.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 03/05] Drivers: Char: mwave: Makefile: Makefile clean up
Date: Sat, 16 Oct 2010 09:26:51 -0400
Message-Id: <1287235613-1545-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
References: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile and use
ccflags-y option.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/char/mwave/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mwave/Makefile b/drivers/char/mwave/Makefile
index 754c9e2..26b4fce 100644
--- a/drivers/char/mwave/Makefile
+++ b/drivers/char/mwave/Makefile
@@ -6,10 +6,10 @@
 
 obj-$(CONFIG_MWAVE) += mwave.o
 
-mwave-objs := mwavedd.o smapi.o tp3780i.o 3780i.o
+mwave-y := mwavedd.o smapi.o tp3780i.o 3780i.o
 
 # To have the mwave driver disable other uarts if necessary
 # EXTRA_CFLAGS += -DMWAVE_FUTZ_WITH_OTHER_DEVICES
 
 # To compile in lots (~20 KiB) of run-time enablable printk()s for debugging:
-EXTRA_CFLAGS += -DMW_TRACE
+ccflags-y := -DMW_TRACE
-- 
1.7.3.1.104.gc752e

