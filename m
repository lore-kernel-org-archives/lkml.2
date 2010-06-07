Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab0FGSuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:50:07 -0400
Received: from mail.perches.com ([173.55.12.10]:2701 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab0FGSuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:03 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Steve Underwood <steveu@coppice.org>, David Rowe <david@rowetel.com>
Subject: [PATCH 06/17] MAINTAINERS: Add STAGING - ECHO CANCELLER
Date: Mon,  7 Jun 2010 11:49:40 -0700
Message-Id: <fa295cedb779fb73a7ca68b8b01d0d9ea5d5e480.1275935090.git.joe@perches.com>
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
index cc9d158..b6366a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5480,6 +5480,12 @@ M:	Scott Smedley <ss@aao.gov.au>
 S:	Odd Fixes
 F:	drivers/staging/dt3155/
 
+STAGING - ECHO CANCELLER
+M:	Steve Underwood <steveu@coppice.org>
+M:	David Rowe <david@rowetel.com>
+S:	Odd Fixes
+F:	drivers/staging/echo/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

