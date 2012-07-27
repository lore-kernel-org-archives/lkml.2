Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab2G0Mjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:39:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61394 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2G0MjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:39:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        sameo@linux.intel.com, alsa-devel@alsa-project.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4/7] mfd: ab8500-core: Apply the AB8500 CODEC's compatible string to its MFD cell
Date: Fri, 27 Jul 2012 13:38:51 +0100
Message-Id: <1343392734-11805-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
References: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a compatible string for the AB8500 CODEC to aid in
configuration property look-up from its associated Device Tree
node.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 626b4ec..0c5b70f 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1076,6 +1076,7 @@ static struct mfd_cell __devinitdata ab8500_devs[] = {
 	},
 	{
 		.name = "ab8500-codec",
+		.of_compatible = "stericsson,ab8500-codec",
 	},
 };
 
-- 
1.7.9.5

