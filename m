Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1IVIIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:08:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44292 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1IVIIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:08:40 -0400
X-IronPort-AV: E=Sophos;i="4.68,421,1312171200"; 
   d="scan'208";a="164254359"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>,
        Alexander Indenbaum <baum@tehutinetworks.net>,
        Andy Gospodarek <andy@greyhouse.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: tehuti: Alexander Indenbaum's address bounces
Date: Thu, 22 Sep 2011 09:08:26 +0100
Message-ID: <1316678906-17113-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1316678008-16842-9-git-send-email-ian.campbell@citrix.com>
References: <1316678008-16842-9-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got:
	Generating server: Tehuti.onmicrosoft.com

	baum@tehutinetworks.net
	#< #5.1.1 smtp;550 5.1.1 RESOLVER.ADR.RecipNotFound; not found> #SMTP#

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Alexander Indenbaum <baum@tehutinetworks.net>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 579713e..4a8a9c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6370,7 +6370,6 @@ S:	Supported
 F:	arch/arm/mach-tegra
 
 TEHUTI ETHERNET DRIVER
-M:	Alexander Indenbaum <baum@tehutinetworks.net>
 M:	Andy Gospodarek <andy@greyhouse.net>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
1.7.2.5

