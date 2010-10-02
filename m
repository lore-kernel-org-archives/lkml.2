Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab0JBQiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0JBQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mvdQJO8fyyULFdKFZaEV2lMzdwL3UKdILXtwpDjRhL5l9sNfWOIZNtSZ17dEUcTJnC
         IcVk3ncp97LQn7Nz8qkfS/k2ocNnmVyb1jP5San5x6dA8F+LqFW6lrMHa/+q6OX4rOho
         x8iObQboYklzBqznLQEknln2Y0R6FeS6WLr40=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 02/20] Staging: cxt1e1: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:51 -0400
Message-Id: <1286037489-28439-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/cxt1e1/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cxt1e1/Makefile b/drivers/staging/cxt1e1/Makefile
index 10020d7..a524a62 100644
--- a/drivers/staging/cxt1e1/Makefile
+++ b/drivers/staging/cxt1e1/Makefile
@@ -1,8 +1,8 @@
 obj-$(CONFIG_CXT1E1)	+= cxt1e1.o
 
-EXTRA_CFLAGS += -DSBE_PMCC4_ENABLE
-EXTRA_CFLAGS += -DSBE_ISR_TASKLET
-EXTRA_CFLAGS += -DSBE_INCLUDE_SYMBOLS
+ccflags-y := -DSBE_PMCC4_ENABLE
+ccflags-y += -DSBE_ISR_TASKLET
+ccflags-y += -DSBE_INCLUDE_SYMBOLS
 
 cxt1e1-objs += 	\
   ossiRelease.o 	\
-- 
1.7.3.1.50.g1e633

