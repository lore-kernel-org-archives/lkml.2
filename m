Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2DEEBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 00:01:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48846 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2DEEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 00:01:38 -0400
Message-ID: <1333598493.10597.7.camel@phoenix>
Subject: [PATCH 5/6] regulator: pcap: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 12:01:33 +0800
In-Reply-To: <1333598216.10597.3.camel@phoenix>
References: <1333598216.10597.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcap-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 781bf34..b55128d 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -241,7 +241,7 @@ static struct regulator_ops pcap_regulator_ops = {
 		.owner		= THIS_MODULE,			\
 	}
 
-static struct regulator_desc pcap_regulators[] = {
+static const struct regulator_desc pcap_regulators[] = {
 	VREG(V1), VREG(V2), VREG(V3), VREG(V4), VREG(V5), VREG(V6), VREG(V7),
 	VREG(V8), VREG(V9), VREG(V10), VREG(VAUX1), VREG(VAUX2), VREG(VAUX3),
 	VREG(VAUX4), VREG(VSIM), VREG(VSIM2), VREG(VVIB), VREG(SW1), VREG(SW2),
-- 
1.7.5.4



