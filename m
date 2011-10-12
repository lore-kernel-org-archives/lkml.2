Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1JLMEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:04:43 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:53071 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1JLMEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:04:42 -0400
Subject: [PATCH] [TRIVIAL] ARM: imx: Fix typo
 'MACH_MX31_3DS_MXC_NAND_USE_BBT'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 14:04:22 +0200
Message-ID: <1318421062.2336.4.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This is trivial because this is what apparently was intended. On the
other hand this should open code paths that were hidden until now. So
perhaps this needs the maintainer's approval. (I cannot meaningfully
test this.)

 arch/arm/mach-imx/mach-mx31_3ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index c20be75..5750ca5 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -542,7 +542,7 @@ static const struct mxc_nand_platform_data
 mx31_3ds_nand_board_info __initconst = {
 	.width		= 1,
 	.hw_ecc		= 1,
-#ifdef MACH_MX31_3DS_MXC_NAND_USE_BBT
+#ifdef CONFIG_MACH_MX31_3DS_MXC_NAND_USE_BBT
 	.flash_bbt	= 1,
 #endif
 };
-- 
1.7.4.4



