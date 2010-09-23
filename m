Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0IWGv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:51:58 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57073 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955Ab0IWGv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:51:56 -0400
From: matt mooney <mfm@muteddisk.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 11/20] parisc: change to new flag variable
Date: Wed, 22 Sep 2010 23:51:05 -0700
Message-Id: <1285224665-29831-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/parisc/math-emu/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/math-emu/Makefile b/arch/parisc/math-emu/Makefile
index 1f3f225..0bd63b0 100644
--- a/arch/parisc/math-emu/Makefile
+++ b/arch/parisc/math-emu/Makefile
@@ -3,7 +3,7 @@
 #
 
 # See arch/parisc/math-emu/README
-EXTRA_CFLAGS += -Wno-parentheses -Wno-implicit-function-declaration \
+ccflags-y := -Wno-parentheses -Wno-implicit-function-declaration \
 	-Wno-uninitialized -Wno-strict-prototypes -Wno-return-type \
 	-Wno-implicit-int
 
-- 
1.7.2.1

