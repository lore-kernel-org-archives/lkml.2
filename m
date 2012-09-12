Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780Ab2ILRHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:07:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719Ab2ILRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:38 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/15] arch/arm/mach-s3c24xx/mach-h1940.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:16 +0200
Message-Id: <1347469402-27557-9-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 arch/arm/mach-s3c24xx/mach-h1940.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index bb8d008..02ef7d5 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -460,7 +460,7 @@ static void h1940_set_mmc_power(unsigned char power_mode, unsigned short vdd)
 		break;
 	default:
 		break;
-	};
+	}
 }
 
 static struct s3c24xx_mci_pdata h1940_mmc_cfg __initdata = {

