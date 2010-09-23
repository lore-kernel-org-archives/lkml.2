Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0IWGvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:51:15 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:59753 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab0IWGvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:51:13 -0400
From: matt mooney <mfm@muteddisk.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 05/20] h8300: change to new flag variable
Date: Wed, 22 Sep 2010 23:50:23 -0700
Message-Id: <1285224623-29602-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_AFLAGS with asflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/h8300/boot/compressed/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/boot/compressed/Makefile b/arch/h8300/boot/compressed/Makefile
index d6189e0..6745cb1 100644
--- a/arch/h8300/boot/compressed/Makefile
+++ b/arch/h8300/boot/compressed/Makefile
@@ -5,7 +5,7 @@
 #
 
 targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o
-EXTRA_AFLAGS	:= -traditional
+asflags-y	:= -traditional
 
 OBJECTS = $(obj)/head.o $(obj)/misc.o
 
-- 
1.7.2.1

