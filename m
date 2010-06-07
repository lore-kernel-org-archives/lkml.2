Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0FGSwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:52:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2701 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0FGSuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:05 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 08/17] MAINTAINERS: Add STAGING - HYPER-V (MICROSOFT)
Date: Mon,  7 Jun 2010 11:49:42 -0700
Message-Id: <30d996a1585126a37ecff700bd02932d0eebcf10.1275935091.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ca1314c..71e6fe3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5491,6 +5491,12 @@ M:	David Täht <d@teklibre.com>
 S:	Odd Fixes
 F:	drivers/staging/frontier/
 
+STAGING - HYPER-V (MICROSOFT)
+M:	Hank Janssen <hjanssen@microsoft.com>
+M:	Haiyang Zhang <haiyangz@microsoft.com>
+S:	Odd Fixes
+F:	drivers/staging/hv/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

