Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847Ab2DLVsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:48:11 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47910 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab2DLVsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:48:10 -0400
From: mjr@cs.wisc.edu
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, Matt Renzelmann <mjr@cs.wisc.edu>
Subject: [PATCH] drivers/leds/leds-lp5523.c: add attribute list NULL terminator
Date: Thu, 12 Apr 2012 16:43:27 -0500
Message-Id: <1334267007-10555-1-git-send-email-mjr@cs.wisc.edu>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Renzelmann <mjr@cs.wisc.edu>

Our driver testing tool found that the lp5523_attributes array is
missing a null-terminator.  All other attribute arrays need one.  This
patch adds it.

Signed-off-by: Matt Renzelmann <mjr@cs.wisc.edu>
---
 drivers/leds/leds-lp5523.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 857a3e1..397091f 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -755,6 +755,7 @@ static struct attribute *lp5523_attributes[] = {
 	&dev_attr_engine2_leds.attr,
 	&dev_attr_engine3_load.attr,
 	&dev_attr_engine3_leds.attr,
+	NULL
 };
 
 static const struct attribute_group lp5523_group = {
-- 
1.7.5.4

