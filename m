Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0FGSwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:52:43 -0400
Received: from mail.perches.com ([173.55.12.10]:2696 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0FGSuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:06 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 09/17] MAINTAINERS: Add STAGING - INDUSTRIAL IO
Date: Mon,  7 Jun 2010 11:49:43 -0700
Message-Id: <81391f52a009e825f5a3bfd73a71ba24190d6f3b.1275935091.git.joe@perches.com>
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
index 71e6fe3..680d602 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5497,6 +5497,11 @@ M:	Haiyang Zhang <haiyangz@microsoft.com>
 S:	Odd Fixes
 F:	drivers/staging/hv/
 
+STAGING - INDUSTRIAL IO
+M:	Jonathan Cameron <jic23@cam.ac.uk>
+S:	Odd Fixes
+F:	drivers/staging/iio/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

