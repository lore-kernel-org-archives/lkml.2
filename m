Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2EKISf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:18:35 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:42035 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2EKISc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:18:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKjKrE9bdWOb/2dsb2JhbABEtB6BB4IWAQVnEhBRVwYTiBK7DIsghhQElX2QQIJrgVQ
X-IronPort-AV: E=Sophos;i="4.75,570,1330902000"; 
   d="scan'208";a="513690777"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Staging ipack: added more info in Kconfig's help about ipack
Date: Fri, 11 May 2012 10:17:16 +0200
Message-Id: <1336724236-21665-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/Kconfig |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
index 4f4b9d6..af32178 100644
--- a/drivers/staging/ipack/Kconfig
+++ b/drivers/staging/ipack/Kconfig
@@ -5,7 +5,11 @@
 menuconfig IPACK_BUS
 	tristate "IndustryPack bus support"
 	---help---
-	  If you say Y here you get support for the IndustryPack Framework.
+	  If you say Y here you get support for the IndustryPack Framework
+	  for drivers for many types of boards that support this industrial
+	  bus. The IndustryPack Framework is a virtual bus allowing to
+	  communicate between carrier and mezzanine cards connected through
+	  this bus.
 
 if IPACK_BUS
 
-- 
1.7.10

