Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab0FITlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:41:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2935 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab0FITil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:41 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Leo Chen <leochen@broadcom.com>,
       Scott Branden <sbranden@broadcom.com>
Subject: [PATCH 01/12] MAINTAINERS: Update ARM/BCMRING MTD NAND DRIVER file patterns
Date: Wed,  9 Jun 2010 12:38:27 -0700
Message-Id: <33700eb588cfe3882682b6b052ecec9485179951.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Leo Chen <leochen@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 67accd7..2af46b6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -576,7 +576,6 @@ L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/nand/bcm_umi_nand.c
 F:	drivers/mtd/nand/bcm_umi_bch.c
-F:	drivers/mtd/nand/bcm_umi_hamming.c
 F:	drivers/mtd/nand/nand_bcm_umi.h
 
 ARM/CAVIUM NETWORKS CNS3XXX MACHINE SUPPORT
-- 
1.7.1.244.gbdc4

