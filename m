Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1GGSRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:17:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33163 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1GGSRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:17:41 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/2] Altera-stapl: Clean up makefile (-y instead of -objs)
Date: Thu,  7 Jul 2011 14:17:24 -0400
Message-Id: <1310062645-4344-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.6.131.g99019
In-Reply-To: <1310062645-4344-1-git-send-email-tdent48227@gmail.com>
References: <1310062645-4344-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs
because -objs is deprecated.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/altera-stapl/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/altera-stapl/Makefile b/drivers/staging/altera-stapl/Makefile
index 055f61ee..ddeede3 100644
--- a/drivers/staging/altera-stapl/Makefile
+++ b/drivers/staging/altera-stapl/Makefile
@@ -1,3 +1,3 @@
-altera-stapl-objs = altera-lpt.o altera-jtag.o altera-comp.o altera.o
+altera-stapl-y := altera-lpt.o altera-jtag.o altera-comp.o altera.o
 
 obj-$(CONFIG_ALTERA_STAPL) += altera-stapl.o
-- 
1.7.6.131.g99019

