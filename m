Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2LRNup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:50:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39673 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2LRNun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:50:43 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-be-50d074b15466
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        p.paneri@samsung.com
Subject: [PATCH v2] usb: phy: samsung: Add support to set pmu isolation
Date: Tue, 18 Dec 2012 19:26:06 +0530
Message-id: <1355838966-11269-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355810167-18425-2-git-send-email-gautam.vivek@samsung.com>
References: <1355810167-18425-2-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkWndjyYUAg959khaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZbyed4m54JZBRd/Bl4wNjOfVuxg5OSQETCS2
	bF3HBGGLSVy4t56ti5GLQ0hgKaPEuo4PLDBFL04uYYJILGKU2PTwGCuEM5lJYuGcX2wgVWwC
	uhJNb3cxgtgiArISh6/8ZgYpYhbYySyx9F4/WJGwgLvEhMcvmUFsFgFViY87P4Pt5hXwkPh3
	cznUHQoSb24/A6vhFPCUuNfawApiCwHVXDl1nxWiV0Di2+RDQOdxANXLSmw6ALZLQuAxm8Tb
	TU+hzpaUOLjiBssERuEFjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MQJD8/S/Z1I7GFc2
	WBxiFOBgVOLhvZF/IUCINbGsuDL3EKMEB7OSCO+bOKAQb0piZVVqUX58UWlOavEhRh+gSyYy
	S4km5wPjJq8k3tDYxNzU2NTSyMjM1BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGxiqH
	FAbzn7cmnLrg+lr9wnO12TFqkU7uCvvYW5yu9ddsVL7sNl8/5gnf7vN1STP52hc0f2u86P36
	QeeGPB+9jnldW/bFiv1auzfAZVNacNrBrN3Tii++31aYoOvYOz+ibF7do3cnmSs8Dx7MrRQQ
	aC7Levts9mGVSOFVp+fxf3upwlG6uWnvHiWW4oxEQy3mouJEAM7zQwR6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jAd2NJRcCDPZeYLS4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj9bxL
	zAW3DCr6Dr5kbGA8r97FyMkhIWAi8eLkEiYIW0ziwr31bF2MXBxCAosYJTY9PMYK4Uxmklg4
	5xcbSBWbgK5E09tdjCC2iICsxOErv5lBipgFdjJLLL3XD1YkLOAuMeHxS2YQm0VAVeLjzs9g
	K3gFPCT+3VwOtU5B4s3tZ2A1nAKeEvdaG1hBbCGgmiun7rNOYORdwMiwilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM48J9J7WBc2WBxiFGAg1GJh/dG/oUAIdbEsuLK3EOMEhzMSiK8b+KA
	QrwpiZVVqUX58UWlOanFhxh9gK6ayCwlmpwPjMq8knhDYxNzU2NTSxMLEzNLHMJK4rzNHikB
	QgLpiSWp2ampBalFMOOYODilGhhndElYX1hUXJpiojD50tOrNUfK9l/rE+jRKPeTb38YMfUN
	67qtvxIalDjv5M3yTJ1Y+DVDacf2freFtl3K4o8+zUrp5eDZO59rt95OD8FtfC8iQwUNRHJb
	8hrmsPWZJH5ayaOdOWfdk6U7L5r4/N8QUL02Wi/Xx+Dioerttg39q7673/12K1aJpTgj0VCL
	uag4EQA1/9CnqQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse device node data in order to get
required properties to set pmu isolation for usb-phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

Changes from v1:
 - Changed the name of property for phy handler from'samsung,usb-phyctrl'
   to 'samsung,usb-phyhandle' to make it look more generic.
 - Similarly 'samsung,phyctrl-reg' is changed to 'samsung,phyhandle-reg'
 - Added a check for 'samsung,usb-phyhandle' before getting node from
   phandle.
 - Putting the node using 'of_node_put()' which had been missed.
 - Adding necessary check for the pointer in 'samsung_usbphy_set_isolation()'
   to avoid any NULL pointer dereferencing.
 - Unmapping the register ioremapped in 'samsung_usbphy_parse_dt_param()'.


 .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +++
 drivers/usb/phy/samsung-usbphy.c                   |   94 ++++++++++++++++++--
 2 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 7b26e2d..a7b28b2 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -9,3 +9,15 @@ Required properties:
 - compatible : should be "samsung,exynos4210-usbphy"
 - reg : base physical address of the phy registers and length of memory mapped
 	region.
+
+Optional properties:
+- samsung,usb-phyhandle : should point to usb-phyhandle sub-node which provides
+			binding data to enable/disable device PHY handled by
+			PMU register.
+
+			Required properties:
+			- compatible : should be "samsung,usbdev-phyctrl" for
+					DEVICE type phy.
+			- samsung,phyhandle-reg: base physical address of
+						PHY_CONTROL register in PMU.
+- samsung,enable-mask : should be '1'
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 5c5e1bb5..4ceabe3 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -72,6 +72,8 @@ enum samsung_cpu_type {
  * @dev: The parent device supplied to the probe function
  * @clk: usb phy clock
  * @regs: usb phy register memory base
+ * @devctrl_reg: usb device phy-control pmu register memory base
+ * @en_mask: enable mask
  * @ref_clk_freq: reference clock frequency selection
  * @cpu_type: machine identifier
  */
@@ -81,12 +83,73 @@ struct samsung_usbphy {
 	struct device	*dev;
 	struct clk	*clk;
 	void __iomem	*regs;
+	void __iomem	*devctrl_reg;
+	u32		en_mask;
 	int		ref_clk_freq;
 	int		cpu_type;
 };
 
 #define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
 
+static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
+{
+	struct device_node *usb_phyctrl;
+	u32 reg;
+	int lenp;
+
+	if (!sphy->dev->of_node) {
+		sphy->devctrl_reg = NULL;
+		return -ENODEV;
+	}
+
+	if (of_get_property(sphy->dev->of_node, "samsung,usb-phyhandle", &lenp)) {
+		usb_phyctrl = of_parse_phandle(sphy->dev->of_node,
+						"samsung,usb-phyhandle", 0);
+		if (!usb_phyctrl) {
+			dev_warn(sphy->dev, "Can't get usb-phy handle\n");
+			sphy->devctrl_reg = NULL;
+		}
+
+		of_property_read_u32(usb_phyctrl, "samsung,phyhandle-reg", &reg);
+
+		sphy->devctrl_reg = ioremap(reg, SZ_4);
+
+		of_property_read_u32(sphy->dev->of_node, "samsung,enable-mask",
+							&sphy->en_mask);
+		of_node_put(usb_phyctrl);
+	} else {
+		dev_warn(sphy->dev, "Can't get usb-phy handle\n");
+		sphy->devctrl_reg = NULL;
+	}
+
+	return 0;
+}
+
+/*
+ * Set isolation here for phy.
+ * SOCs control this by controlling corresponding PMU registers
+ */
+static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int on)
+{
+	void __iomem *usb_phyctrl_reg;
+	u32 en_mask = sphy->en_mask;
+	u32 reg;
+
+	usb_phyctrl_reg = sphy->devctrl_reg;
+
+	if (!usb_phyctrl_reg) {
+		dev_warn(sphy->dev, "Can't set pmu isolation\n");
+		return;
+	}
+
+	reg = readl(usb_phyctrl_reg);
+
+	if (on)
+		writel(reg & ~en_mask, usb_phyctrl_reg);
+	else
+		writel(reg | en_mask, usb_phyctrl_reg);
+}
+
 /*
  * Returns reference clock frequency selection value
  */
@@ -199,6 +262,8 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 	/* Disable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(false);
+	else
+		samsung_usbphy_set_isolation(sphy, false);
 
 	/* Initialize usb phy registers */
 	samsung_usbphy_enable(sphy);
@@ -228,6 +293,8 @@ static void samsung_usbphy_shutdown(struct usb_phy *phy)
 	/* Enable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(true);
+	else
+		samsung_usbphy_set_isolation(sphy, true);
 
 	clk_disable_unprepare(sphy->clk);
 }
@@ -249,17 +316,12 @@ static inline int samsung_usbphy_get_driver_data(struct platform_device *pdev)
 static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 {
 	struct samsung_usbphy *sphy;
-	struct samsung_usbphy_data *pdata;
+	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
 	struct device *dev = &pdev->dev;
 	struct resource *phy_mem;
 	void __iomem	*phy_base;
 	struct clk *clk;
-
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "%s: no platform data defined\n", __func__);
-		return -EINVAL;
-	}
+	int ret;
 
 	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!phy_mem) {
@@ -283,7 +345,20 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	sphy->dev		= &pdev->dev;
+	sphy->dev = &pdev->dev;
+
+	ret = samsung_usbphy_parse_dt_param(sphy);
+	if (ret) {
+		/* fallback to pdata */
+		if (!pdata) {
+			dev_err(&pdev->dev,
+				"%s: no device data found\n", __func__);
+			return -ENODEV;
+		} else {
+			sphy->plat = pdata;
+		}
+	}
+
 	sphy->plat		= pdata;
 	sphy->regs		= phy_base;
 	sphy->clk		= clk;
@@ -305,6 +380,9 @@ static int __exit samsung_usbphy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
+	if (sphy->devctrl_reg)
+		iounmap(sphy->devctrl_reg);
+
 	return 0;
 }
 
-- 
1.7.6.5

