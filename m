Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2LRFtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:49:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35957 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LRFtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:49:42 -0500
X-AuditID: cbfee61b-b7f616d00000319b-b5-50d003f4b1b9
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        p.paneri@samsung.com
Subject: [PATCH] usb: phy: samsung: Add support to set pmu isolation
Date: Tue, 18 Dec 2012 11:26:07 +0530
Message-id: <1355810167-18425-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355810167-18425-1-git-send-email-gautam.vivek@samsung.com>
References: <1355810167-18425-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkVvcL84UAg5vflSwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgymg+1MJS8Ei9Yv6K2+wNjKsVuhg5OSQETCR+
	zd3FCGGLSVy4t56ti5GLQ0hgKaPE0UV97DBFlzftZoVILGKUeLh3IZQzmUliQusvJpAqNgFd
	iaa3EKNEBGQlDl/5zQxSxCywk1li6b1+NpCEsICLxKej04FsDg4WAVWJ82+dQMK8Ah4S38/f
	hTpDQeLN7WfMIDangKfE0zkPwGwhoJo9n7+A2SwCAhLfJh9iARkjAbRr0wFmiNbHbBJTnlpD
	2JISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRmBYnv73THoH46oGi0OM
	AhyMSjy8P+PPBwixJpYVV+YeYpTgYFYS4b29BijEm5JYWZValB9fVJqTWnyI0QfokInMUqLJ
	+cCYySuJNzQ2MTc1NrU0MjIzNcUhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0fMEL1NT
	+8JrWpPO6liWBqz6eeJn++Gvyz+nT5Dn2pEawFbTbJRsc5pJj/eGsd1dU7mLJQIH5K+sfr7O
	vXG1kJDbEfO9Yse0XKU7vps4/M466L0t+Vpn5CtBpxO/d86NrC/wXXBW59eVGwuszlzJZHuo
	eGHjbR6pzRt9YqconVNx3FOTUfOISYmlOCPRUIu5qDgRADxFwQ54AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAd0vzBcCDNq3S1lc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRfKiF
	peCResX8FbfZGxhXK3QxcnJICJhIXN60mxXCFpO4cG89WxcjF4eQwCJGiYd7F7JCOJOZJCa0
	/mICqWIT0JVoeruLEcQWEZCVOHzlNzNIEbPATmaJpff62UASwgIuEp+OTgeyOThYBFQlzr91
	AgnzCnhIfD9/lxFim4LEm9vPmEFsTgFPiadzHoDZQkA1ez5/YZ7AyLuAkWEVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnDYP5PewbiqweIQowAHoxIP78/48wFCrIllxZW5hxglOJiVRHhv
	rwEK8aYkVlalFuXHF5XmpBYfYvQBOmois5Rocj4wJvNK4g2NTcxNjU0tTSxMzCxxCCuJ8zZ7
	pAQICaQnlqRmp6YWpBbBjGPi4JRqYNzwynad7loF00VqXRPZ8x8LC1vezv/AHXbbJTbfIo3B
	Jn+q5AF2hVcvFWvcjJfrftpUr78xz1UrUJ719bLLPduM1k6uXWt3KOUTu8S/VI7Qx8sbXCMb
	WxSihErCrzUWaPSX+oinLQtusDV54/m/3Xmy3nwlW/67dvwtGifiBRa+V5NXW9SvxFKckWio
	xVxUnAgAV9Iiy6gCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse device node data in order to get
required properties to set pmu isolation for usb-phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/usb/samsung-usbphy.txt     |   10 +++
 drivers/usb/phy/samsung-usbphy.c                   |   80 ++++++++++++++++++--
 2 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 7b26e2d..112eaa6 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -9,3 +9,13 @@ Required properties:
 - compatible : should be "samsung,exynos4210-usbphy"
 - reg : base physical address of the phy registers and length of memory mapped
 	region.
+- samsung,usb-phyctrl : should point to usb-phyctrl sub-node which provides
+			binding data to enable/disable device PHY handled by
+			PMU register.
+
+			Required properties:
+			- compatible : should be "samsung,usbdev-phyctrl" for
+					DEVICE type phy.
+			- samsung,phyctrl-reg: base physical address of
+						PHY_CONTROL register in PMU.
+- samsung,enable-mask : should be '1'
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 5c5e1bb5..ef394c3 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -72,6 +72,8 @@ enum samsung_cpu_type {
  * @dev: The parent device supplied to the probe function
  * @clk: usb phy clock
  * @regs: usb phy register memory base
+ * @devctrl_reg: usb phy-control pmu register memory base
+ * @en_mask: enable mask
  * @ref_clk_freq: reference clock frequency selection
  * @cpu_type: machine identifier
  */
@@ -81,12 +83,62 @@ struct samsung_usbphy {
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
+
+	if (!sphy->dev->of_node) {
+		sphy->devctrl_reg = NULL;
+		return -ENODEV;
+	}
+
+	usb_phyctrl = of_parse_phandle(sphy->dev->of_node,
+					"samsung,usb-phyctrl", 0);
+	if (!usb_phyctrl) {
+		dev_dbg(sphy->dev, "Can't get usb-phy control node\n");
+		sphy->devctrl_reg = NULL;
+		return -ENODEV;
+	}
+
+	of_property_read_u32(usb_phyctrl, "samsung,phyctrl-reg", &reg);
+
+	sphy->devctrl_reg = ioremap(reg, SZ_4);
+
+	of_property_read_u32(sphy->dev->of_node, "samsung,enable-mask",
+							&sphy->en_mask);
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
@@ -199,6 +251,8 @@ static int samsung_usbphy_init(struct usb_phy *phy)
 	/* Disable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(false);
+	else
+		samsung_usbphy_set_isolation(sphy, false);
 
 	/* Initialize usb phy registers */
 	samsung_usbphy_enable(sphy);
@@ -228,6 +282,8 @@ static void samsung_usbphy_shutdown(struct usb_phy *phy)
 	/* Enable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(true);
+	else
+		samsung_usbphy_set_isolation(sphy, true);
 
 	clk_disable_unprepare(sphy->clk);
 }
@@ -249,17 +305,12 @@ static inline int samsung_usbphy_get_driver_data(struct platform_device *pdev)
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
@@ -283,7 +334,20 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
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
-- 
1.7.6.5

