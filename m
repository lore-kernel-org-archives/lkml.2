Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1JNM2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:28:15 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57823 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1JNM2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:28:14 -0400
Subject: [PATCH 02/21] blackfin: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:27:27 +0200
Message-ID: <1318595247.6132.58.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/blackfin/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c747629..abe5a9e 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -248,10 +248,6 @@ config HOTPLUG_CPU
 	depends on SMP && HOTPLUG
 	default y
 
-config HAVE_LEGACY_PER_CPU_AREA
-	def_bool y
-	depends on SMP
-
 config BF_REV_MIN
 	int
 	default 0 if (BF51x || BF52x || (BF54x && !BF54xM))
-- 
1.7.4.4




