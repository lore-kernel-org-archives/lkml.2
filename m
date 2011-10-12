Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1JLMSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:18:55 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:41234 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1JLMSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:18:54 -0400
Subject: [PATCH] [TRIVIAL] ARM: mxc: fix Kconfig typo 'i.MX51'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 14:18:51 +0200
Message-ID: <1318421931.2336.12.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/plat-mxc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index a5353fc..4c8fdbc 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -39,7 +39,7 @@ config ARCH_MX503
 	select ARCH_MX50_SUPPORTED
 	select ARCH_MX53_SUPPORTED
 	help
-	  This enables support for machines using Freescale's i.MX50 and i.MX51
+	  This enables support for machines using Freescale's i.MX50 and i.MX53
 	  processors.
 
 config ARCH_MX51
-- 
1.7.4.4



