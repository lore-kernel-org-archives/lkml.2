Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2LROiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:38:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47080 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2LROiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:38:10 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e2-50d07fd1286b
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        jg1.han@samsung.com, yulgon.kim@samsung.com, kishon@ti.com,
        p.paneri@samsung.com
Subject: [PATCH v5 1/4] ARM: EXYNOS: Update & move usb-phy types to generic
 include layer
Date: Tue, 18 Dec 2012 20:13:03 +0530
Message-id: <1355841786-13307-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkVvdi/YUAg2mHlSwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyuh7fpKlYLFSxfYPJ9kaGJ/LdDFyckgImEg8
	+/eMHcIWk7hwbz1bFyMXh5DAUkaJzTOWsMMUzfm1lRUiMZ1RYvm26SwQzmQmiUntV5hAqtgE
	dCWa3u5iBLFFBGQlDl/5zQxSxCzQyyxx6uQRFpCEsEC0xK1LS8EaWARUJd5Ouw62glfAQ+LG
	85OMEOsUJN7cfsYMYnMKeEo0HjkGVM8BtM1Douu2FESrgMS3yYdYQMISQLs2HQBbJSHwmk2i
	cdZ/VogxkhIHV9xgmcAovICRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGYGCe/vdMegfj
	qgaLQ4wCHIxKPLw/488HCLEmlhVX5h5ilOBgVhLhfRN3IUCINyWxsiq1KD++qDQntfgQow/Q
	JROZpUST84FRk1cSb2hsYm5qbGppZGRmaopDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QD
	Y9S8+2oSufMMDhsnTZ1xab3szqijAVvX6lbEL71eKLy2RMI+ewJrs3u/7lOJScV87zsO+Uz7
	N7so5mGjwqkivtWXTzpeX9khf27/b8vXbdrWpwV2/zf3rF58Ne9mXUjLGbZ3VcsDHghu17w/
	9U359EjfyyKJxx9kGWdvy3CK/vlvfQKDvUqpmRJLcUaioRZzUXEiACFzW9V5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd2L9RcCDCZNE7a4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjGj7/lJ
	loLFShXbP5xka2B8LtPFyMkhIWAiMefXVlYIW0ziwr31bF2MXBxCAtMZJZZvm84C4UxmkpjU
	foUJpIpNQFei6e0uRhBbREBW4vCV38wgRcwCvcwSp04eYQFJCAtES9y6tBSsgUVAVeLttOvs
	IDavgIfEjecnGSHWKUi8uf2MGcTmFPCUaDxyDKieA2ibh0TXbakJjLwLGBlWMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgSH/TPpHYyrGiwOMQpwMCrx8P6MPx8gxJpYVlyZe4hRgoNZSYT3
	TdyFACHelMTKqtSi/Pii0pzU4kOMPkBHTWSWEk3OB8ZkXkm8obGJuamxqaWJhYmZJQ5hJXHe
	Zo+UACGB9MSS1OzU1ILUIphxTBycUg2M7dMPLrB6v9Wp4VLRTItDc7L+7e24VL9Fm636pYfV
	1zqfwEW/2X7JL+99deP077o9S90ylu/YsTL4+5T+9G1z8goP8B/WWzNl18pjd/yXSiy7G/99
	xVStyO2m0UGhJ76tfxb/NeK89ZcHn37Plfs5t+32h/aM9QXJshOPP5HT4t7sW/DkYFvwsRtK
	LMUZiYZazEXFiQAs7OCoqAIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating the names of usb-phy types to more generic names:
USB_PHY_TYPE_DEIVCE & USB_PHY_TYPE_HOST; and further update
its dependencies.

Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ehci-s5p.c         |    9 +++++----
 drivers/usb/host/ohci-exynos.c      |    9 +++++----
 include/linux/usb/samsung_usb_phy.h |   16 ++++++++++++++++
 3 files changed, 26 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/usb/samsung_usb_phy.h

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 319dcfa..46ca5ef 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
 #define EHCI_INSNREG00(base)			(base + 0x90)
@@ -164,7 +165,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -198,7 +199,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
 	usb_remove_hcd(hcd);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -229,7 +230,7 @@ static int s5p_ehci_suspend(struct device *dev)
 	rc = ehci_suspend(hcd, do_wakeup);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -246,7 +247,7 @@ static int s5p_ehci_resume(struct device *dev)
 	clk_prepare_enable(s5p_ehci->clk);
 
 	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index aa3b884..804fb62 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-exynos.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
 struct exynos_ohci_hcd {
@@ -153,7 +154,7 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ohci = hcd_to_ohci(hcd);
 	ohci_hcd_init(ohci);
@@ -184,7 +185,7 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 	usb_remove_hcd(hcd);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -229,7 +230,7 @@ static int exynos_ohci_suspend(struct device *dev)
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -249,7 +250,7 @@ static int exynos_ohci_resume(struct device *dev)
 	clk_prepare_enable(exynos_ohci->clk);
 
 	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ohci_resume(hcd, false);
 
diff --git a/include/linux/usb/samsung_usb_phy.h b/include/linux/usb/samsung_usb_phy.h
new file mode 100644
index 0000000..9167826
--- /dev/null
+++ b/include/linux/usb/samsung_usb_phy.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ *		http://www.samsung.com/
+ *
+ * Defines phy types for samsung usb phy controllers - HOST or DEIVCE.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+enum samsung_usb_phy_type {
+	USB_PHY_TYPE_DEVICE,
+	USB_PHY_TYPE_HOST,
+};
-- 
1.7.6.5

