Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2ENKxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2ENKxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:52 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Mon, 14 May 2012 19:54:51 +0900
Message-Id: <20120514105451.8596.92367.sendpatchset@w520>
In-Reply-To: <20120514105424.8596.38355.sendpatchset@w520>
References: <20120514105424.8596.38355.sendpatchset@w520>
Subject: [PATCH 03/03] ARM: Undelete KZM9D mach-type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Undelete the KZM9D mach-type to allow build of board
for EMEV2 SoC support.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/tools/mach-types |    1 +
 1 file changed, 1 insertion(+)

--- 0001/arch/arm/tools/mach-types
+++ work/arch/arm/tools/mach-types	2012-05-14 19:38:03.000000000 +0900
@@ -530,6 +530,7 @@ nokia_rm680		MACH_NOKIA_RM680	NOKIA_RM68
 msm8960_sim		MACH_MSM8960_SIM	MSM8960_SIM		3230
 msm8960_rumi3		MACH_MSM8960_RUMI3	MSM8960_RUMI3		3231
 gsia18s			MACH_GSIA18S		GSIA18S			3234
+kzm9d			MACH_KZM9D		KZM9D			3246
 mx53_loco		MACH_MX53_LOCO		MX53_LOCO		3273
 tx53			MACH_TX53		TX53			3279
 encore			MACH_ENCORE		ENCORE			3284
