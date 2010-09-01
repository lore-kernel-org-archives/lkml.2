Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0IANkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:40:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38932 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0IANks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:40:48 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging/comedi: fix syntax error
Date: Wed,  1 Sep 2010 15:40:22 +0200
Message-Id: <1283348427-6183-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know how gcc interprets this, but it wouldn't surprise me if it
choose something different than start-of-comment

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index d7d768e..129b2f9 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -1,4 +1,4 @@
-//**
+/**
 @verbatim
 
 Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
-- 
1.7.1

