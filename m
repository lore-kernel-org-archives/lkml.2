Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2ALG5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:57:21 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61673 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2ALG5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:57:19 -0500
Message-ID: <1326351429.3471.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: s5m8767: Add missing breaks
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 12 Jan 2012 14:57:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against Mark's regulator tree (for-next-next branch).

 drivers/regulator/s5m8767.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index b3d356f..4061012 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -742,15 +742,19 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 		case 15:
 			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xc0, 0xf0);
+			break;
 		case 25:
 			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xd0, 0xf0);
+			break;
 		case 50:
 			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xe0, 0xf0);
+			break;
 		case 100:
 			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0xf0, 0xf0);
+			break;
 		default:
 			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 					0x90, 0xf0);
-- 
1.7.5.4



