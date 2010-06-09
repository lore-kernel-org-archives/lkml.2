Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab0FITjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:39:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2949 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab0FITit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:49 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jean Tourrilhes <jt@hpl.hp.com>
Subject: [PATCH 11/12] MAINTAINERS: Remove section WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
Date: Wed,  9 Jun 2010 12:38:37 -0700
Message-Id: <0f7d3ebb9e9e01b87c00fc3061861f2172ea790d.1276112118.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1d794e3b353b50ab5d9d46f7c15607f9ec8c78e0 removed it

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
---
 MAINTAINERS |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 56a87ac..fb3a7d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6220,14 +6220,6 @@ F:	Documentation/watchdog/
 F:	drivers/watchdog/
 F:	include/linux/watchdog.h
 
-WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
-M:	Jean Tourrilhes <jt@hpl.hp.com>
-L:	linux-wireless@vger.kernel.org
-W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
-S:	Maintained
-F:	Documentation/networking/wavelan.txt
-F:	drivers/staging/wavelan/
-
 WD7000 SCSI DRIVER
 M:	Miroslav Zagorac <zaga@fly.cc.fer.hr>
 L:	linux-scsi@vger.kernel.org
-- 
1.7.1.244.gbdc4

