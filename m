Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0JPN1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:27:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab0JPN1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WBFkMyB/VL3vlFM+CMmhPcH1/4oLzZ7PgBGsoGssjpXEVZ6UQ6N1Z1r3H1ZtARD3do
         Zx1K2D8zRN5cuqvqsXbFGT80lgpalNy/OIBytxuh2bhI8upHupyHjROA5nSKQFLEG3+7
         ZlrECsqwUmhCZNCKwjr65J7KtAm9uyKfzobu8=
From: Tracey Dent <tdent48227@gmail.com>
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Cc: mhw@wittsend.com, minyard@acm.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 05/05] Drivers: char: rio: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 09:26:53 -0400
Message-Id: <1287235613-1545-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
References: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/char/rio/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/rio/Makefile b/drivers/char/rio/Makefile
index 2d1c5a7..1661875 100644
--- a/drivers/char/rio/Makefile
+++ b/drivers/char/rio/Makefile
@@ -8,5 +8,5 @@
 
 obj-$(CONFIG_RIO) += rio.o
 
-rio-objs := rio_linux.o rioinit.o rioboot.o riocmd.o rioctrl.o riointr.o \
+rio-y := rio_linux.o rioinit.o rioboot.o riocmd.o rioctrl.o riointr.o \
             rioparam.o rioroute.o riotable.o riotty.o
-- 
1.7.3.1.104.gc752e

