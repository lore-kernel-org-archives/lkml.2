Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2L0Q7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:59:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33140 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2L0Q7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:59:07 -0500
X-AuditID: cbfee61b-b7f616d00000319b-9c-50dc7e59d8d1
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        patches@linaro.org
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
 <1355399644-29417-2-git-send-email-thomas.abraham@linaro.org>
 <CACRpkdaQ10CgoFXtk4EyqL4LWVpsdEAdrmy5R-_Rqm5fJdqS4A@mail.gmail.com>
 <CAJuYYwTZkzCXjowhKaJ253Oji07eDdEjMvNssyL1ThWtETswSQ@mail.gmail.com>
In-reply-to: <CAJuYYwTZkzCXjowhKaJ253Oji07eDdEjMvNssyL1ThWtETswSQ@mail.gmail.com>
Subject: RE: [PATCH 1/3] pinctrl: exynos: add exynos5250 SoC specific data
Date: Thu, 27 Dec 2012 08:58:57 -0800
Message-id: <017801cde453$77b03eb0$6710bc10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ22IaoyeydFvGJHT6/7CmrSguD5AGirMLTAWWQ2hgA6DN3A5a6SAJw
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zfd3IujsBBv2XhSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJW3W9jLTguXjGtfzJbA+Nf4S5GDg4JAROJjq3aXYyc
	QKaYxIV769m6GLk4hASWMUrsv/qKHSJhInFs9wQWiMQiRokLO44xQzh/GSWmHV/PCFLFJqAh
	cfj9M3aQqSICcRILdlmC1DALTGaU6NyyCmrsdCaJWXd/sYA0cAoES7w9MI8VxBYW8JK41r2U
	CcRmEVCV+LF8C9hqXgFLidm3djFD2IISPybfA+tlFtCSWL/zOBOELS+xec1bZohTFSR2nH0N
	dpCIgJvE6g1L2SFqxCUmPXjIDjFfQOLb5EMsEO/LSmw6APaMhMA6dol5e+cwQsyRlDi44gbL
	BEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIyTOpHcwrmqw
	OMQowMGoxMOraH07QIg1say4MvcQowQHs5II7/f4OwFCvCmJlVWpRfnxRaU5qcWHGH2ALp/I
	LCWanA9MAXkl8YbGxiZmJqYm5pam5qY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MM5I
	0ZVqyLGP0Qu/xPzbbK99UoLugsfsUiu3cuuV5T+srmxuyHedeVDCbWIW56LtygpHOW6d0Wj8
	tVmv4moja+D6K+HzxRZKhXmK9/JG3dVWqLRSLzg2Lzbn16KEsD27O/cJtr3VzPE0vOsYsLx1
	/rV29hebK5Yd1S8OmZOgKx93rJj1it88JZbijERDLeai4kQAd8b6ouACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd3IujsBBpcX8Flc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrLrfxlpwXLxi
	Wv9ktgbGv8JdjJwcEgImEsd2T2CBsMUkLtxbz9bFyMUhJLCIUeLCjmPMEM5fRolpx9czglSx
	CWhIHH7/jL2LkYNDRCBOYsEuS5AaZoHJjBKdW1ZBdU9nkph19xfYWE6BYIm3B+axgtjCAl4S
	17qXMoHYLAKqEj+Wb2EHsXkFLCVm39rFDGELSvyYfA+sl1lAS2L9zuNMELa8xOY1b5khTlWQ
	2HH2NdhBIgJuEqs3LGWHqBGXmPTgIfsERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHMfPpHcwrmqwOMQowMGoxMOraH07QIg1say4MvcQowQHs5II7/f4
	OwFCvCmJlVWpRfnxRaU5qcWHGH2APp3ILCWanA9MMXkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9
	UgKEBNITS1KzU1MLUotgxjFxcEo1MHJLuy1Nz/l/Vendsk1JuTcl6/N52Z0fPJbzuuY6y0+z
	ybR+S1DvqdXz+5ZZic75yWGkPzNJR98kQKF+0Tl3Mcm9zrvy3t3afU7rbTXjmXW8G/NXX5u4
	5/WuboF7fhuOpge7XL6i1chy1oeTU/oou+P/6apL9c1mqr885TM34lmW/Jxkq2I9KSWW4oxE
	Qy3mouJEAM8YZncQAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> Hi Linus,
> 
> On 14 December 2012 21:21, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Thu, Dec 13, 2012 at 12:54 PM, Thomas Abraham
> > <thomas.abraham@linaro.org> wrote:
> >
> >> Add Samsung Exynos5250 SoC specific data to enable pinctrl support for
> >> all platforms based on Exynos5250.
> >>
> >> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> >
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > For this series, I guess you'll fix it through the Samsung tree?
> 
> Thanks for your ack. Since there are patches to be prepared for
> migrating the rest of Exynos5250 related code to the pinctrl
> framework, it would be easier if this series goes through the Samsung
> tree.
> 
I applied this series, thanks.

And I think, would be clear if the config could be changed like following.

8<----------------------------------------------------------------------
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] pinctrl: exynos: change PINCTRL_EXYNOS option

Since pinctrl-exynos can support exynos4 and exynos5 so changed
the option name to PINCTRL_EXYNOS for more clarity.

Cc: Thomas Abraham <Thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 91d5b6f..e1f63e7 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -412,7 +412,7 @@ config MACH_EXYNOS4_DT
 	select CPU_EXYNOS4210
 	select HAVE_SAMSUNG_KEYPAD if INPUT_KEYBOARD
 	select PINCTRL
-	select PINCTRL_EXYNOS4
+	select PINCTRL_EXYNOS
 	select USE_OF
 	help
 	  Machine support for Samsung Exynos4 machine with device tree
enabled.
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c31aeb0..f59feab 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -185,8 +185,8 @@ config PINCTRL_SAMSUNG
 	select PINMUX
 	select PINCONF
 
-config PINCTRL_EXYNOS4
-	bool "Pinctrl driver data for Exynos4 SoC"
+config PINCTRL_EXYNOS
+	bool "Pinctrl driver data for Samsung EXYNOS SoCs"
 	depends on OF && GPIOLIB
 	select PINCTRL_SAMSUNG
 
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index fc4606f..6e87e52 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
 obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
-obj-$(CONFIG_PINCTRL_EXYNOS4)	+= pinctrl-exynos.o
+obj-$(CONFIG_PINCTRL_EXYNOS)	+= pinctrl-exynos.o
 obj-$(CONFIG_PINCTRL_EXYNOS5440)	+= pinctrl-exynos5440.o
 obj-$(CONFIG_PINCTRL_XWAY)	+= pinctrl-xway.o
 obj-$(CONFIG_PINCTRL_LANTIQ)	+= pinctrl-lantiq.o
8<----------------------------------------------------------------------

- Kukjin

