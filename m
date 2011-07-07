Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1GGR4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:56:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41924 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1GGR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:56:36 -0400
Date: Thu, 7 Jul 2011 13:56:32 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Altera-stapl: Clean up makefile (-y instead of -objs)
Message-ID: <20110707175632.GA2700@tj-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
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

