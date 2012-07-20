Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab2GTMnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:43:49 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:40738
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777Ab2GTMns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:43:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH] mpc85xx_defconfig: add IDE support for MPC85xxCDS
Date: Fri, 20 Jul 2012 20:45:25 +0800
Message-ID: <1342788325-27609-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IDE support for MPC85xxCDS.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/configs/mpc85xx_defconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index 03ee911..45eda33 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -105,6 +105,8 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_SIZE=131072
 CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_LEGACY=y
+CONFIG_IDE=y
+CONFIG_BLK_DEV_VIA82CXXX=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
-- 
1.6.4.1


