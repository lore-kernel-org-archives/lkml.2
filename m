Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0KMDaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48513 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab0KMDaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61718506"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 03/14] msm: iommu: Use more consistent naming in platform data
Date: Fri, 12 Nov 2010 19:29:49 -0800
Message-Id: <1289619000-13167-4-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename all the IOMMU platform devices so that the names are
more consistent with the rest of the codebase.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/devices-msm8x60-iommu.c |  136 ++++++++++++++--------------
 1 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm8x60-iommu.c b/arch/arm/mach-msm/devices-msm8x60-iommu.c
index 89b9d44..9e657e0 100644
--- a/arch/arm/mach-msm/devices-msm8x60-iommu.c
+++ b/arch/arm/mach-msm/devices-msm8x60-iommu.c
@@ -259,55 +259,55 @@ static struct platform_device msm_root_iommu_dev = {
 	.id = -1,
 };
 
-static struct msm_iommu_dev jpegd_smmu = {
+static struct msm_iommu_dev jpegd_iommu = {
 	.name = "jpegd",
 	.clk_rate = -1
 };
 
-static struct msm_iommu_dev vpe_smmu = {
+static struct msm_iommu_dev vpe_iommu = {
 	.name = "vpe"
 };
 
-static struct msm_iommu_dev mdp0_smmu = {
+static struct msm_iommu_dev mdp0_iommu = {
 	.name = "mdp0"
 };
 
-static struct msm_iommu_dev mdp1_smmu = {
+static struct msm_iommu_dev mdp1_iommu = {
 	.name = "mdp1"
 };
 
-static struct msm_iommu_dev rot_smmu = {
+static struct msm_iommu_dev rot_iommu = {
 	.name = "rot"
 };
 
-static struct msm_iommu_dev ijpeg_smmu = {
+static struct msm_iommu_dev ijpeg_iommu = {
 	.name = "ijpeg"
 };
 
-static struct msm_iommu_dev vfe_smmu = {
+static struct msm_iommu_dev vfe_iommu = {
 	.name = "vfe",
 	.clk_rate = -1
 };
 
-static struct msm_iommu_dev vcodec_a_smmu = {
+static struct msm_iommu_dev vcodec_a_iommu = {
 	.name = "vcodec_a"
 };
 
-static struct msm_iommu_dev vcodec_b_smmu = {
+static struct msm_iommu_dev vcodec_b_iommu = {
 	.name = "vcodec_b"
 };
 
-static struct msm_iommu_dev gfx3d_smmu = {
+static struct msm_iommu_dev gfx3d_iommu = {
 	.name = "gfx3d",
 	.clk_rate = 27000000
 };
 
-static struct msm_iommu_dev gfx2d0_smmu = {
+static struct msm_iommu_dev gfx2d0_iommu = {
 	.name = "gfx2d0",
 	.clk_rate = 27000000
 };
 
-static struct platform_device msm_device_smmu_jpegd = {
+static struct platform_device msm_device_iommu_jpegd = {
 	.name = "msm_iommu",
 	.id = 0,
 	.dev = {
@@ -317,7 +317,7 @@ static struct platform_device msm_device_smmu_jpegd = {
 	.resource = msm_iommu_jpegd_resources,
 };
 
-static struct platform_device msm_device_smmu_vpe = {
+static struct platform_device msm_device_iommu_vpe = {
 	.name = "msm_iommu",
 	.id = 1,
 	.dev = {
@@ -327,7 +327,7 @@ static struct platform_device msm_device_smmu_vpe = {
 	.resource = msm_iommu_vpe_resources,
 };
 
-static struct platform_device msm_device_smmu_mdp0 = {
+static struct platform_device msm_device_iommu_mdp0 = {
 	.name = "msm_iommu",
 	.id = 2,
 	.dev = {
@@ -337,7 +337,7 @@ static struct platform_device msm_device_smmu_mdp0 = {
 	.resource = msm_iommu_mdp0_resources,
 };
 
-static struct platform_device msm_device_smmu_mdp1 = {
+static struct platform_device msm_device_iommu_mdp1 = {
 	.name = "msm_iommu",
 	.id = 3,
 	.dev = {
@@ -347,7 +347,7 @@ static struct platform_device msm_device_smmu_mdp1 = {
 	.resource = msm_iommu_mdp1_resources,
 };
 
-static struct platform_device msm_device_smmu_rot = {
+static struct platform_device msm_device_iommu_rot = {
 	.name = "msm_iommu",
 	.id = 4,
 	.dev = {
@@ -357,7 +357,7 @@ static struct platform_device msm_device_smmu_rot = {
 	.resource = msm_iommu_rot_resources,
 };
 
-static struct platform_device msm_device_smmu_ijpeg = {
+static struct platform_device msm_device_iommu_ijpeg = {
 	.name = "msm_iommu",
 	.id = 5,
 	.dev = {
@@ -367,7 +367,7 @@ static struct platform_device msm_device_smmu_ijpeg = {
 	.resource = msm_iommu_ijpeg_resources,
 };
 
-static struct platform_device msm_device_smmu_vfe = {
+static struct platform_device msm_device_iommu_vfe = {
 	.name = "msm_iommu",
 	.id = 6,
 	.dev = {
@@ -377,7 +377,7 @@ static struct platform_device msm_device_smmu_vfe = {
 	.resource = msm_iommu_vfe_resources,
 };
 
-static struct platform_device msm_device_smmu_vcodec_a = {
+static struct platform_device msm_device_iommu_vcodec_a = {
 	.name = "msm_iommu",
 	.id = 7,
 	.dev = {
@@ -387,7 +387,7 @@ static struct platform_device msm_device_smmu_vcodec_a = {
 	.resource = msm_iommu_vcodec_a_resources,
 };
 
-static struct platform_device msm_device_smmu_vcodec_b = {
+static struct platform_device msm_device_iommu_vcodec_b = {
 	.name = "msm_iommu",
 	.id = 8,
 	.dev = {
@@ -397,7 +397,7 @@ static struct platform_device msm_device_smmu_vcodec_b = {
 	.resource = msm_iommu_vcodec_b_resources,
 };
 
-static struct platform_device msm_device_smmu_gfx3d = {
+static struct platform_device msm_device_iommu_gfx3d = {
 	.name = "msm_iommu",
 	.id = 9,
 	.dev = {
@@ -407,7 +407,7 @@ static struct platform_device msm_device_smmu_gfx3d = {
 	.resource = msm_iommu_gfx3d_resources,
 };
 
-static struct platform_device msm_device_smmu_gfx2d0 = {
+static struct platform_device msm_device_iommu_gfx2d0 = {
 	.name = "msm_iommu",
 	.id = 10,
 	.dev = {
@@ -553,7 +553,7 @@ static struct platform_device msm_device_jpegd_src_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 0,
 	.dev = {
-		.parent = &msm_device_smmu_jpegd.dev,
+		.parent = &msm_device_iommu_jpegd.dev,
 	},
 };
 
@@ -561,7 +561,7 @@ static struct platform_device msm_device_jpegd_dst_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 1,
 	.dev = {
-		.parent = &msm_device_smmu_jpegd.dev,
+		.parent = &msm_device_iommu_jpegd.dev,
 	},
 };
 
@@ -569,7 +569,7 @@ static struct platform_device msm_device_vpe_src_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 2,
 	.dev = {
-		.parent = &msm_device_smmu_vpe.dev,
+		.parent = &msm_device_iommu_vpe.dev,
 	},
 };
 
@@ -577,7 +577,7 @@ static struct platform_device msm_device_vpe_dst_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 3,
 	.dev = {
-		.parent = &msm_device_smmu_vpe.dev,
+		.parent = &msm_device_iommu_vpe.dev,
 	},
 };
 
@@ -585,7 +585,7 @@ static struct platform_device msm_device_mdp_vg1_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 4,
 	.dev = {
-		.parent = &msm_device_smmu_mdp0.dev,
+		.parent = &msm_device_iommu_mdp0.dev,
 	},
 };
 
@@ -593,7 +593,7 @@ static struct platform_device msm_device_mdp_rgb1_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 5,
 	.dev = {
-		.parent = &msm_device_smmu_mdp0.dev,
+		.parent = &msm_device_iommu_mdp0.dev,
 	},
 };
 
@@ -601,7 +601,7 @@ static struct platform_device msm_device_mdp_vg2_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 6,
 	.dev = {
-		.parent = &msm_device_smmu_mdp1.dev,
+		.parent = &msm_device_iommu_mdp1.dev,
 	},
 };
 
@@ -609,7 +609,7 @@ static struct platform_device msm_device_mdp_rgb2_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 7,
 	.dev = {
-		.parent = &msm_device_smmu_mdp1.dev,
+		.parent = &msm_device_iommu_mdp1.dev,
 	},
 };
 
@@ -617,7 +617,7 @@ static struct platform_device msm_device_rot_src_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 8,
 	.dev = {
-		.parent = &msm_device_smmu_rot.dev,
+		.parent = &msm_device_iommu_rot.dev,
 	},
 };
 
@@ -625,7 +625,7 @@ static struct platform_device msm_device_rot_dst_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 9,
 	.dev = {
-		.parent = &msm_device_smmu_rot.dev,
+		.parent = &msm_device_iommu_rot.dev,
 	},
 };
 
@@ -633,7 +633,7 @@ static struct platform_device msm_device_ijpeg_src_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 10,
 	.dev = {
-		.parent = &msm_device_smmu_ijpeg.dev,
+		.parent = &msm_device_iommu_ijpeg.dev,
 	},
 };
 
@@ -641,7 +641,7 @@ static struct platform_device msm_device_ijpeg_dst_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 11,
 	.dev = {
-		.parent = &msm_device_smmu_ijpeg.dev,
+		.parent = &msm_device_iommu_ijpeg.dev,
 	},
 };
 
@@ -649,7 +649,7 @@ static struct platform_device msm_device_vfe_imgwr_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 12,
 	.dev = {
-		.parent = &msm_device_smmu_vfe.dev,
+		.parent = &msm_device_iommu_vfe.dev,
 	},
 };
 
@@ -657,7 +657,7 @@ static struct platform_device msm_device_vfe_misc_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 13,
 	.dev = {
-		.parent = &msm_device_smmu_vfe.dev,
+		.parent = &msm_device_iommu_vfe.dev,
 	},
 };
 
@@ -665,7 +665,7 @@ static struct platform_device msm_device_vcodec_a_stream_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 14,
 	.dev = {
-		.parent = &msm_device_smmu_vcodec_a.dev,
+		.parent = &msm_device_iommu_vcodec_a.dev,
 	},
 };
 
@@ -673,7 +673,7 @@ static struct platform_device msm_device_vcodec_a_mm1_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 15,
 	.dev = {
-		.parent = &msm_device_smmu_vcodec_a.dev,
+		.parent = &msm_device_iommu_vcodec_a.dev,
 	},
 };
 
@@ -681,7 +681,7 @@ static struct platform_device msm_device_vcodec_b_mm2_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 16,
 	.dev = {
-		.parent = &msm_device_smmu_vcodec_b.dev,
+		.parent = &msm_device_iommu_vcodec_b.dev,
 	},
 };
 
@@ -689,7 +689,7 @@ static struct platform_device msm_device_gfx3d_rbpa_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 17,
 	.dev = {
-		.parent = &msm_device_smmu_gfx3d.dev,
+		.parent = &msm_device_iommu_gfx3d.dev,
 	},
 };
 
@@ -697,7 +697,7 @@ static struct platform_device msm_device_gfx3d_cpvgttc_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 18,
 	.dev = {
-		.parent = &msm_device_smmu_gfx3d.dev,
+		.parent = &msm_device_iommu_gfx3d.dev,
 	},
 };
 
@@ -705,7 +705,7 @@ static struct platform_device msm_device_gfx3d_smmu_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 19,
 	.dev = {
-		.parent = &msm_device_smmu_gfx3d.dev,
+		.parent = &msm_device_iommu_gfx3d.dev,
 	},
 };
 
@@ -713,7 +713,7 @@ static struct platform_device msm_device_gfx2d0_pixv1_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 20,
 	.dev = {
-		.parent = &msm_device_smmu_gfx2d0.dev,
+		.parent = &msm_device_iommu_gfx2d0.dev,
 	},
 };
 
@@ -721,36 +721,36 @@ static struct platform_device msm_device_gfx2d0_texv3_ctx = {
 	.name = "msm_iommu_ctx",
 	.id = 21,
 	.dev = {
-		.parent = &msm_device_smmu_gfx2d0.dev,
+		.parent = &msm_device_iommu_gfx2d0.dev,
 	},
 };
 
 static struct platform_device *msm_iommu_devs[] = {
-	&msm_device_smmu_jpegd,
-	&msm_device_smmu_vpe,
-	&msm_device_smmu_mdp0,
-	&msm_device_smmu_mdp1,
-	&msm_device_smmu_rot,
-	&msm_device_smmu_ijpeg,
-	&msm_device_smmu_vfe,
-	&msm_device_smmu_vcodec_a,
-	&msm_device_smmu_vcodec_b,
-	&msm_device_smmu_gfx3d,
-	&msm_device_smmu_gfx2d0,
+	&msm_device_iommu_jpegd,
+	&msm_device_iommu_vpe,
+	&msm_device_iommu_mdp0,
+	&msm_device_iommu_mdp1,
+	&msm_device_iommu_rot,
+	&msm_device_iommu_ijpeg,
+	&msm_device_iommu_vfe,
+	&msm_device_iommu_vcodec_a,
+	&msm_device_iommu_vcodec_b,
+	&msm_device_iommu_gfx3d,
+	&msm_device_iommu_gfx2d0,
 };
 
 static struct msm_iommu_dev *msm_iommu_data[] = {
-	&jpegd_smmu,
-	&vpe_smmu,
-	&mdp0_smmu,
-	&mdp1_smmu,
-	&rot_smmu,
-	&ijpeg_smmu,
-	&vfe_smmu,
-	&vcodec_a_smmu,
-	&vcodec_b_smmu,
-	&gfx3d_smmu,
-	&gfx2d0_smmu,
+	&jpegd_iommu,
+	&vpe_iommu,
+	&mdp0_iommu,
+	&mdp1_iommu,
+	&rot_iommu,
+	&ijpeg_iommu,
+	&vfe_iommu,
+	&vcodec_a_iommu,
+	&vcodec_b_iommu,
+	&gfx3d_iommu,
+	&gfx2d0_iommu,
 };
 
 static struct platform_device *msm_iommu_ctx_devs[] = {
@@ -826,7 +826,7 @@ static int msm8x60_iommu_init(void)
 		ret = platform_device_register(msm_iommu_devs[i]);
 
 		if (ret != 0) {
-			pr_err("platform_device_register smmu failed, "
+			pr_err("platform_device_register iommu failed, "
 			       "i = %d\n", i);
 			goto failure_unwind;
 		}
@@ -837,7 +837,7 @@ static int msm8x60_iommu_init(void)
 					       msm_iommu_ctx_data[i],
 					       sizeof(*msm_iommu_ctx_devs[i]));
 		if (ret != 0) {
-			pr_err("platform_device_add_data smmu failed, "
+			pr_err("platform_device_add_data iommu failed, "
 			       "i = %d\n", i);
 			goto failure_unwind2;
 		}
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

