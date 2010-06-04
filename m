Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab0FDKmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:42:07 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:56799 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab0FDKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:42:05 -0400
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: ben-linux@fluff.org, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 2/2] MAINTAINERS: add maintainer for SAMSUNG ARM ARCHITECTURES
Date: Fri,  4 Jun 2010 19:36:34 +0900
Message-Id: <1275647794-30634-2-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275647794-30634-1-git-send-email-kgene.kim@samsung.com>
References: <1275647794-30634-1-git-send-email-kgene.kim@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d41149..f4e4c61 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -896,11 +896,13 @@ S:	Maintained
 
 ARM/SAMSUNG ARM ARCHITECTURES
 M:	Ben Dooks <ben-linux@fluff.org>
+M:	Kukjin Kim <kgene.kim@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-samsung/
 F:	arch/arm/plat-s3c24xx/
+F:	arch/arm/plat-s5p/
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-- 
1.6.2.5

