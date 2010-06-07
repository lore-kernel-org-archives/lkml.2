Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0FGSuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:50:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2722 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0FGSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:09 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Ossama Othman <ossama.othman@intel.com>
Subject: [PATCH 10/17] MAINTAINERS: Add STAGING - MEMORY RESTRICTED ACCESS REGIONS
Date: Mon,  7 Jun 2010 11:49:44 -0700
Message-Id: <e3787a804250bf1eb8c6301021d195238982fb77.1275935091.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 680d602..06eed7b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5502,6 +5502,11 @@ M:	Jonathan Cameron <jic23@cam.ac.uk>
 S:	Odd Fixes
 F:	drivers/staging/iio/
 
+STAGING - MEMORY RESTRICTED ACCESS REGIONS (INTEL MOORESTOWN)
+M:	Ossama Othman <ossama.othman@intel.com>
+S:	Odd Fixes
+F:	drivers/staging/memrar/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

