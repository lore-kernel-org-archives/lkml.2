Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2EHHVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:21:33 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:58582 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab2EHHVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:21:30 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 10/12] ARM: imx: eukrea_mbimxsd25: don't free twice GPIO_SWITCH1
Date: Tue,  8 May 2012 09:20:25 +0200
Message-Id: <1336461627-30315-10-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336461627-30315-1-git-send-email-eric@eukrea.com>
References: <1336461627-30315-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c b/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c
index cafa109..fcc366a 100644
--- a/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c
+++ b/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c
@@ -292,7 +292,6 @@ void __init eukrea_mbimxsd25_baseboard_init(void)
 
 	gpio_request(GPIO_LCDPWR, "LCDPWR");
 	gpio_direction_output(GPIO_LCDPWR, 1);
-	gpio_free(GPIO_SWITCH1);
 
 	i2c_register_board_info(0, eukrea_mbimxsd_i2c_devices,
 				ARRAY_SIZE(eukrea_mbimxsd_i2c_devices));
-- 
1.7.7.6

