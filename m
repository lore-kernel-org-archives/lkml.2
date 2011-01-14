Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1ANJoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:44:44 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:46890 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751550Ab1ANJoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:44:24 -0500
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux@simtec.co.uk, Ben Dooks <ben-linux@fluff.org>,
        Vincent Sanders <vince@simtec.co.uk>,
        Simtec Support <support@simtec.co.uk>
Subject: [PATCH 3/3] MAINTAINERS: Fixup Simtec support email entries
Date: Fri, 14 Jan 2011 09:44:15 +0000
Message-Id: <fd0227dd223f5c88e559b2902d5124107ffb7c6a.1294998254.git.ben-linux@fluff.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
References: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
In-Reply-To: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
References: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support@simtec.co.uk address is for direct customer support only, the
EB2410ITX and EB110ATX entries should direct to the Simtec Linux Team
address of linux@simtec.co.uk

Also add correct email address for Vincent Sanders

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Simtec Support <support@simtec.co.uk>
Cc: Simtec Linux Team <linux@simtec.co.uk>
---
 MAINTAINERS |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a99ddf..3f5dc25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5557,13 +5557,15 @@ F:	include/linux/sfi*.h
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
-M:	Vincent Sanders <support@simtec.co.uk>
+P:	Vincent Sanders <support@simtec.co.uk>
+M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
-M:	Vincent Sanders <support@simtec.co.uk>
+P:	Vincent Sanders <vince@simtec.co.uk>
+M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
 F:	arch/arm/mach-s3c2410/mach-bast.c
-- 
1.7.1

