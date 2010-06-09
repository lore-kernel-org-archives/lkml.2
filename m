Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab0FITjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:39:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2943 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460Ab0FITis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:48 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] MAINTAINERS: Remove section STRIP
Date: Wed,  9 Jun 2010 12:38:36 -0700
Message-Id: <3c0e398ea218af9cde62b28a28793e184f64efd8.1276112118.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f80a3f62383bf673c310926d55142d51f118926d removed it

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6402d30..56a87ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5434,11 +5434,6 @@ M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
 F:	drivers/net/starfire*
 
-STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
-S:	Orphan
-F:	drivers/staging/strip/strip.c
-F:	include/linux/if_strip.h
-
 STRADIS MPEG-2 DECODER DRIVER
 M:	Nathan Laredo <laredo@gnu.org>
 W:	http://www.stradis.com/
-- 
1.7.1.244.gbdc4

