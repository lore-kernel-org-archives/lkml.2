Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1LMGdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:33:01 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:55027 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1LMGc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:59 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        Fabio Estevam <fabio.estevam@freescale.com> (commit_signer:3/11=27%),
        Richard Zhao <richard.zhao@freescale.com> (commit_signer:2/11=18%),
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de> (commit_signer:2/11=18%),
        Andre Silva <andre.silva@freescale.com> (commit_signer:1/11=9%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 13/19] enable uncompress log on cpuimx35sd
Date: Tue, 13 Dec 2011 07:31:45 +0100
Message-Id: <1323757911-25217-13-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/uncompress.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/uncompress.h b/arch/arm/plat-mxc/include/mach/uncompress.h
index 88fd404..477971b 100644
--- a/arch/arm/plat-mxc/include/mach/uncompress.h
+++ b/arch/arm/plat-mxc/include/mach/uncompress.h
@@ -98,6 +98,7 @@ static __inline__ void __arch_decomp_setup(unsigned long arch_id)
 	case MACH_TYPE_PCM043:
 	case MACH_TYPE_LILLY1131:
 	case MACH_TYPE_VPR200:
+	case MACH_TYPE_EUKREA_CPUIMX35SD:
 		uart_base = MX3X_UART1_BASE_ADDR;
 		break;
 	case MACH_TYPE_MAGX_ZN5:
-- 
1.7.6.4

