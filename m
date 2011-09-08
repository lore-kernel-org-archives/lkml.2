Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab1IHNi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:38:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58928 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab1IHNiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:38:24 -0400
From: Deepthy Ravi <deepthy.ravi@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <laurent.pinchart@ideasonboard.com>, <g.liakhovetski@gmx.de>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 7/8] omap3evm: camera: Configure BT656 interface
Date: Thu, 8 Sep 2011 19:07:26 +0530
Message-ID: <1315489046-16332-1-git-send-email-deepthy.ravi@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
---
 arch/arm/mach-omap2/board-omap3evm-camera.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
index 718dd6d..e92fb13 100644
--- a/arch/arm/mach-omap2/board-omap3evm-camera.c
+++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
@@ -141,9 +141,14 @@ static struct isp_v4l2_subdevs_group omap3evm_camera_subdevs[] = {
 		.interface      = ISP_INTERFACE_PARALLEL,
 		.bus            = {
 			.parallel       = {
-				.data_lane_shift        = 1,
-				.clk_pol                = 0,
-				.bridge                 = 0,
+				.width			= 8,
+				.data_lane_shift	= 1,
+				.clk_pol		= 0,
+				.hs_pol			= 0,
+				.vs_pol			= 1,
+				.fldmode		= 1,
+				.bridge			= 0,
+				.is_bt656		= 1,
 			},
 		}
 	},
-- 
1.7.0.4

