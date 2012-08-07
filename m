Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2HGJKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:10:51 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33011 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab2HGJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:10:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <galak@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH] mpc85xx_defconfig: add VIA PATA support for MPC85xxCDS
Date: Tue, 7 Aug 2012 17:12:47 +0800
Message-ID: <1344330767-29444-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.6.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
Replace this patch "mpc85xx_defconfig: add IDE support for MPC85xxCDS".

 arch/powerpc/configs/mpc85xx_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index ae9d852..627c257 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -116,6 +116,7 @@ CONFIG_ATA=y
 CONFIG_SATA_AHCI=y
 CONFIG_SATA_FSL=y
 CONFIG_PATA_ALI=y
+CONFIG_PATA_VIA=y
 CONFIG_NETDEVICES=y
 CONFIG_DUMMY=y
 CONFIG_FS_ENET=y
-- 
1.6.4.1


