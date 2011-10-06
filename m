Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935765Ab1JFLMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:12:01 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:39262 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFLMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:12:00 -0400
Subject: [PATCH] [TRIVIAL] bcmring: drop commented out line in Kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 13:11:52 +0200
Message-ID: <1317899512.1933.8.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no file named "drivers/char/bcmring/Kconfig". It seems it has
never been part of the mainline kernel tree. So there's nothing to be
sourced here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/arm/mach-bcmring/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-bcmring/Kconfig b/arch/arm/mach-bcmring/Kconfig
index 457b438..9170d16 100644
--- a/arch/arm/mach-bcmring/Kconfig
+++ b/arch/arm/mach-bcmring/Kconfig
@@ -17,5 +17,3 @@ config BCM_ZRELADDR
 	hex "Compressed ZREL ADDR"
 
 endmenu
-
-# source "drivers/char/bcmring/Kconfig"
-- 
1.7.4.4



