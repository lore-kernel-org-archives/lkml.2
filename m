Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0FGSwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:52:01 -0400
Received: from mail.perches.com ([173.55.12.10]:2724 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0FGSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 11/17] MAINTAINERS: Add STAGING - OTUS 802.11n USB WIRELESS DRIVER
Date: Mon,  7 Jun 2010 11:49:45 -0700
Message-Id: <de848b7990a8a691068c8761543a321f4df3f759.1275935091.git.joe@perches.com>
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
index 06eed7b..4494736 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5507,6 +5507,11 @@ M:	Ossama Othman <ossama.othman@intel.com>
 S:	Odd Fixes
 F:	drivers/staging/memrar/
 
+STAGING - OTUS 802.11n USB WIRELESS DRIVER
+M:	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
+S:	Odd Fixes
+F:	drivers/staging/otus/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

