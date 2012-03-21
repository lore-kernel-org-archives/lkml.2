Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2CUJwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:52:10 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:40021 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab2CUJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:52:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/11] m68k/amiga: Mark z_dev_present() __init
Date: Wed, 21 Mar 2012 10:51:46 +0100
Message-Id: <1332323515-7314-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's called from amiga_init_devices() only, which is __init.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 7fd8b41..1b8db5c 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -57,7 +57,7 @@ static int __init amiga_init_bus(void)
 subsys_initcall(amiga_init_bus);
 
 
-static int z_dev_present(zorro_id id)
+static int __init z_dev_present(zorro_id id)
 {
 	unsigned int i;
 
-- 
1.7.0.4

