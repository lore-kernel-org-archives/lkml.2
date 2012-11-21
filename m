Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2KUEbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:31:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52986 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2KUEbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:31:07 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ec-50ac59083ecf
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v5] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Date: Wed, 21 Nov 2012 13:31:01 +0900
Message-id: <1353472261-17430-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t8zLV2OyDUBBs8uaFpc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL2fpzAVvDKteLX1y3MDYzzzLsYOTkkBEwkOr+eZIKw
	xSQu3FvPBmILCSxjlJhzMh2m5sjz16xdjFxA8emMEjeW3GWEKGphklh63wfEZhPQkfi/7yY7
	iC0iICMx9cp+sAZmgb1MErNfbmYGSQgLREo8fvUKaBsHB4uAqsSKGaIgYV4BD4l9u06zQixT
	kFhw7y3YESwCAhLfJh9iASmXEJCV2HSAGWSkhMARNokLfVvYIOolJQ6uuMEygVFwASPDKkbR
	1ILkguKk9FxDveLE3OLSvHS95PzcTYyQ0JLawbiyweIQowAHoxIP78a1qwOEWBPLiitzDzFK
	cDArifAyyK8JEOJNSaysSi3Kjy8qzUktPsToA3TJRGYp0eR8YNjnlcQbGhsYGxpaGpqZWpoa
	4BBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cDIkqglrP+tZ8uiKxe+3zh6xHp52QplkeLo
	xVe8ruZm+ZUZ79+Tdz+gnLlu11eff+br1ybPLrzExqjGtvtf2qSmY1zXbq90u2jn+mUNC/9a
	/ndLuvLV1USfR6c7NUns5FBKreO867Xx7zP5vtXmKy56f3t786vD7ucTn5VdjAx42VDkcvXg
	92+pSizFGYmGWsxFxYkALSbSt1oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jQV2OyDUBBv1t0haXd81hs/jce4TR
	gcnj8ya5AMaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58A
	XbfMHKDRSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMvR8nsBW8cq34
	9XULcwPjPPMuRk4OCQETiSPPX7NC2GISF+6tZ+ti5OIQEpjOKHFjyV1GkISQQAuTxNL7PiA2
	m4COxP99N9lBbBEBGYmpV/azgjQwC+xlkpj9cjMzSEJYIFLi8atXTF2MHBwsAqoSK2aIgoR5
	BTwk9u06DbVMQWLBvbdsExi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDt1nUjsY
	VzZYHGIU4GBU4uHduHZ1gBBrYllxZe4hRgkOZiURXgb5NQFCvCmJlVWpRfnxRaU5qcWHGH2A
	lk9klhJNzgfGVV5JvKGxiZmRpZGZsYm5sTEOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFIN
	jMUbTLdJz/zyIFH828XSuScufXU4sf0dg8GdnstT731c6TAxzfNWaTNXsZ6JeepXj/PH1zSc
	4Fqf9GOjs5ZATEC59426g/ftOT4rpdmKpkzVO99ceuh78NWaYhGnh4mXVgpKzd305pva4mIz
	noZtjW1hHQlMClPz9ucx30xZ2Pnz67nWw6+arJRYijMSDbWYi4oTASjl5XGKAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports exynos's emulation mode with newly created sysfs node.
Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
management unit. Thermal emulation mode supports software debug for TMU's
operation. User can set temperature manually with software code and TMU
will read current temperature from user value not from sensor's value.
This patch includes also documentary placed under Documentation/thermal/.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
v5
 - Rebase the patch at -next branch of zhang rui's git.
 - Fix EXYNOS_EMULATION_MODE Kconfig option as Amit's comment.
 - Show emulation temperature in millicelsius.
   Storing emulation temperature supports both celsius and mcelsius for input.

v4
 - Fix Typo.
 - Remove unnecessary codes.
 - Add comments about feature of exynos emulation operation to the document.

v3
 - Remove unnecessay variables.
 - Do some code clean in exynos_tmu_emulation_store().
 - Make wrapping function of sysfs node creation function to use
   #ifdefs in minimum.

v2
 exynos_thermal.c
 - Fix build error occured by wrong emulation control register name.
 - Remove exynos5410 dependent codes.
 exynos_thermal_emulation
 - Align indentation.
 Documentation/thermal/exynos_thermal_emulation |   56 +++++++++++++
 drivers/thermal/Kconfig                        |    9 ++
 drivers/thermal/exynos_thermal.c               |  103 ++++++++++++++++++++++++
 3 files changed, 168 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/thermal/exynos_thermal_emulation

diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
new file mode 100644
index 0000000..bc9b057
--- /dev/null
+++ b/Documentation/thermal/exynos_thermal_emulation
@@ -0,0 +1,56 @@
+EXYNOS EMULATION MODE
+========================
+
+Copyright (C) 2012 Samsung Electronics
+
+Written by Jonghwa Lee <jonghwa3.lee@samsung.com>
+
+Description
+-----------
+
+Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal management unit.
+Thermal emulation mode supports software debug for TMU's operation. User can set temperature
+manually with software code and TMU will read current temperature from user value not from
+sensor's value.
+
+Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
+When it's enabled, sysfs node will be created under
+/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
+
+The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
+temperature you want to update to sysfs node, it automatically enable emulation mode and
+current temperature will be changed into it.
+(Exynos also supports user changable delay time which would be used to delay of
+ changing temperature. However, this node only uses same delay of real sensing time, 938us.)
+
+Exynos emulation mode requires synchronous of value changing and enabling. It means when you
+want to update the any value of delay or next temperature, then you have to enable emulation 
+mode at the same time. (Or you have to keep the mode enabling.) If you don't, it fails to
+change the value to updated one and just use last succeessful value repeatedly. That's why
+this node gives users the right to change termerpature only. Just one interface makes it more
+simply to use.
+
+Disabling emulation mode only requires writing value 0 to sysfs node.
+
+
+TEMP	120 |
+	    |
+	100 |
+	    |
+	 80 |
+	    |		     	 	 +-----------
+	 60 |      		     	 |	    |
+	    |	           +-------------|          |
+	 40 |              |         	 |          |
+   	    |		   |	     	 |          |
+	 20 |		   |	     	 |          +----------
+	    |	 	   |	     	 |          |          |
+  	  0 |______________|_____________|__________|__________|_________
+		   A	    	 A	    A	   	       A     TIME
+		   |<----->|	 |<----->|  |<----->|	       |
+		   | 938us |  	 |	 |  |       |          |
+emulation    :  0  50	   |  	 70      |  20      |          0
+current temp :   sensor   50		 70         20	      sensor
+
+
+
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index d96da07..61ab206 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -101,6 +101,15 @@ config EXYNOS_THERMAL
 	  If you say yes here you get support for TMU (Thermal Managment
 	  Unit) on SAMSUNG EXYNOS series of SoC.
 
+config EXYNOS_THERMAL_EMUL
+	bool "EXYNOS TMU emulation mode support"
+	depends on EXYNOS_THERMAL
+	help
+	  Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
+	  Enable this option will be make sysfs node in exynos thermal platform
+	  device directory to support emulation mode. With emulation mode sysfs
+	  node, you can manually input temperature to TMU for simulation purpose.
+
 config DB8500_THERMAL
 	bool "DB8500 thermal management"
 	depends on ARCH_U8500
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 7772d16..75615f2 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -99,6 +99,14 @@
 #define IDLE_INTERVAL 10000
 #define MCELSIUS	1000
 
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+#define EXYNOS_EMUL_TIME	0x57F0
+#define EXYNOS_EMUL_TIME_SHIFT	16
+#define EXYNOS_EMUL_DATA_SHIFT	8
+#define EXYNOS_EMUL_DATA_MASK	0xFF
+#define EXYNOS_EMUL_ENABLE	0x1
+#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
+
 /* CPU Zone information */
 #define PANIC_ZONE      4
 #define WARN_ZONE       3
@@ -832,6 +840,94 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 	return (struct exynos_tmu_platform_data *)
 			platform_get_device_id(pdev)->driver_data;
 }
+
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+static ssize_t exynos_tmu_emulation_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	unsigned int reg;
+	u8 temp_code;
+	int temp = 0;
+
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		goto out;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+	if (reg & EXYNOS_EMUL_ENABLE) {
+		reg >>= EXYNOS_EMUL_DATA_SHIFT;
+		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
+		temp = code_to_temp(data, temp_code);
+	}
+out:
+	return sprintf(buf, "%d\n", temp * MCELSIUS);
+}
+
+static ssize_t exynos_tmu_emulation_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	unsigned int reg;
+	int temp;
+
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		goto out;
+
+	if (!sscanf(buf, "%d\n", &temp) || temp < 0)
+		return -EINVAL;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+
+	if (temp) {
+		/* Both CELSIUS and MCELSIUS type are available for input */
+		if (temp > MCELSIUS)
+			temp /= MCELSIUS;
+
+		reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
+			(temp_to_code(data, (temp / MCELSIUS))
+			 << EXYNOS_EMUL_DATA_SHIFT) | EXYNOS_EMUL_ENABLE;
+	} else {
+		reg &= ~EXYNOS_EMUL_ENABLE;
+	}
+
+	writel(reg, data->base + EXYNOS_EMUL_CON);
+
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+out:
+	return count;
+}
+
+static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
+					exynos_tmu_emulation_store);
+static int create_emulation_sysfs(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_emulation);
+}
+static void remove_emulation_sysfs(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_emulation);
+}
+#else
+static inline int create_emulation_sysfs(struct device *dev) {return 0;}
+static inline void remove_emulation_sysfs(struct device *dev){}
+#endif
+
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
@@ -930,6 +1026,11 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to register thermal interface\n");
 		goto err_clk;
 	}
+
+	ret = create_emulation_sysfs(&pdev->dev);
+	if (ret)
+		dev_err(&pdev->dev, "Failed to create emulation mode sysfs node\n");
+
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
@@ -941,6 +1042,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 
+	remove_emulation_sysfs(&pdev->dev);
+
 	exynos_tmu_control(pdev, false);
 
 	exynos_unregister_thermal();
-- 
1.7.4.1

