Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1BQC7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:59:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39415 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1BQC7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dwQ/xpKdI4/1uzJubzajT4BTvTooux+ACEfCPOlzMYR3LuPUi9LS0ZhdE/g0VNSyXE
         xtq4SSM2i+TJhbjrsUGMd2nrcy9WyEeEmYP4eAauapXQWaxQczff4zXpwvhFDsRF8CJC
         JFD4evGglb1Wh4lcssBHM9MSdazC3rjWQkj6g=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 05/10] Staging: tidspbridge: fixed extern in .c file
Date: Thu, 17 Feb 2011 03:58:49 +0100
Message-Id: <1297911534-31534-5-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 51cae1a..1a6f8dc 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -133,7 +133,8 @@ static int mem_map_vmalloc(struct bridge_dev_context *dev_context,
 				  u32 ul_num_bytes,
 				  struct hw_mmu_map_attrs_t *hw_attrs);
 
-bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr);
+static bool wait_for_start(struct bridge_dev_context *dev_context,
+				u32 dw_sync_addr);
 
 /*  ----------------------------------- Globals */
 
-- 
1.7.1

