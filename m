Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab2KXAbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:31:15 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:55267 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab2KXA10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:26 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Christopher Hoover <ch@murgatroid.com>,
        Christopher Hoover <ch@hpl.hp.com>
Subject: [PATCH 09/24] MAINTAINERS: remove drivers/video/epson1355fb.c
Date: Fri, 23 Nov 2012 22:26:33 -0200
Message-Id: <1353716808-16375-10-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
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
index 0488d14..7f80f95 100644
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

