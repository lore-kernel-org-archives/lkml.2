Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2BPN4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:56:31 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51516 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab2BPN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:56:27 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Danny Kukawka <dkukawka@suse.de>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch/blackfin/mach-bf537/boards/pnav10.c: included linux/export.h twice
Date: Thu, 16 Feb 2012 14:56:24 +0100
Message-Id: <1329400584-32069-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400587;6b0464ba;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/blackfin/mach-bf537/boards/pnav10.c: included 'linux/export.h'
twice. No need to include the file a second time in a #ifdef block
if already included at top. Remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/blackfin/mach-bf537/boards/pnav10.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 6fd8470..7d15a30 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -101,7 +101,6 @@ static struct platform_device smc91x_device = {
 
 #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 #include <linux/bfin_mac.h>
-#include <linux/export.h>
 static const unsigned short bfin_mac_peripherals[] = P_RMII0;
 
 static struct bfin_phydev_platform_data bfin_phydev_data[] = {
-- 
1.7.8.3

