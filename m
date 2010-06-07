Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab0FGSwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:52:05 -0400
Received: from mail.perches.com ([173.55.12.10]:2722 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0FGSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Willy Tarreau <willy@meta-x.org>
Subject: [PATCH 12/17] MAINTAINERS: Add STAGING - PARALLEL LCD/KEYPAD PANEL DRIVER
Date: Mon,  7 Jun 2010 11:49:46 -0700
Message-Id: <86ea0af9863474849b1db4981c40b1cd1bed4d74.1275935091.git.joe@perches.com>
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
index 4494736..33679ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5512,6 +5512,11 @@ M:	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
 S:	Odd Fixes
 F:	drivers/staging/otus/
 
+STAGING -  PARALLEL LCD/KEYPAD PANEL DRIVER
+M:	Willy Tarreau <willy@meta-x.org>
+S:	Odd Fixes
+F:	drivers/staging/panel/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

