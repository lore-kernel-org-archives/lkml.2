Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab1J3L4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 07:56:51 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:33993 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab1J3L4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 07:56:50 -0400
Subject: [PATCH] [RESEND] [TRIVIAL] ARM: imx: Fix typo
 'MACH_MX31_3DS_MXC_NAND_USE_BBT'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 12:56:36 +0100
Message-ID: <1319975796.14409.11.camel@x61.thuisdomein>
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



