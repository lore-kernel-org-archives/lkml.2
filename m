Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2CWKVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:21:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43807 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2CWKVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:21:38 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, martyn.welch@ge.com,
        gregkh@linuxfoundation.org
Subject: [PATCH] staging/vme: Fix module parameters in next-20120323
Date: Fri, 23 Mar 2012 03:21:05 -0700
Message-Id: <1332498065-15573-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loopback should be declared bool, and variant probably shouldn't be
const.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/staging/vme/devices/vme_pio2_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
index 9fedc44..573c800 100644
--- a/drivers/staging/vme/devices/vme_pio2_core.c
+++ b/drivers/staging/vme/devices/vme_pio2_core.c
@@ -35,10 +35,10 @@ static int vector[PIO2_CARDS_MAX];
 static int vector_num;
 static int level[PIO2_CARDS_MAX];
 static int level_num;
-static const char *variant[PIO2_CARDS_MAX];
+static char *variant[PIO2_CARDS_MAX];
 static int variant_num;
 
-static int loopback;
+static bool loopback;
 
 static int pio2_match(struct vme_dev *);
 static int __devinit pio2_probe(struct vme_dev *);
-- 
1.7.7.6

