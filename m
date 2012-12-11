Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2LKVxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:53:45 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:33119 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab2LKVuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:20 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Christopher Hoover <ch@murgatroid.com>,
        Christopher Hoover <ch@hpl.hp.com>
Subject: [PATCH 09/19] MAINTAINERS: remove drivers/video/epson1355fb.c
Date: Tue, 11 Dec 2012 19:49:51 -0200
Message-Id: <1355262601-4263-10-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was removed by commit 1c3a918 (ARM: clps711x: Remove board
support for CEIVA).

Cc: Christopher Hoover <ch@murgatroid.com>
Cc: Christopher Hoover <ch@hpl.hp.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b8dfc72..3bf84d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2889,12 +2889,6 @@ M:	Maxim Levitsky <maximlevitsky@gmail.com>
 S:	Maintained
 F:	drivers/media/rc/ene_ir.*
 
-EPSON 1355 FRAMEBUFFER DRIVER
-M:	Christopher Hoover <ch@murgatroid.com>
-M:	Christopher Hoover <ch@hpl.hp.com>
-S:	Maintained
-F:	drivers/video/epson1355fb.c
-
 EPSON S1D13XXX FRAMEBUFFER DRIVER
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 S:	Maintained
-- 
1.7.11.7

