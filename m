Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2LUSOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:14:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24437 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2LUSOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:14:01 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-76-50d4a6e68749
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Jason Cooper'" <jason@lakedaemon.net>,
        "'Shawn Guo'" <shawn.guo@linaro.org>, "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1356111423-3454-1-git-send-email-tobetter@gmail.com>
 <1356111423-3454-2-git-send-email-tobetter@gmail.com>
In-reply-to: <1356111423-3454-2-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH v2 1/4] ODROID-X: dts: Add board dts file for ODROID-X
Date: Fri, 21 Dec 2012 10:13:50 -0800
Message-id: <007b01cddfa6$f158b460$d40a1d20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLftuks8ZV3ODE8h20z5ESRhVxv1QL53FjblegPd8A=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zQ91ny64EGMyewmpxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyft+9wlawSbTix9pdzA2M7wS6GDk5JARMJA7s72CGsMUkLtxb
	z9bFyMUhJLCMUWJnzx5WmKKeOX1QiemMEns2nmCGcOYxSWzuOABWxSagIXH4/TN2EFtEQE2i
	8W8nK0gRs8BHJolbj7aC7RASqJQ4/2cPUxcjBwengJPEyVkxIGFhAS+JfQ8nMYHYLAKqEjdf
	LQIr4RWwlPh7rwIkzCsgKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+hPlCQ2HH2NSPECVYSVxet
	ZYOoEZeY9OAhO8R4AYlvkw+xgIyXEJCV2HQA7BUJgVXsEr/P97FBzJGUOLjiBssERolZSFbP
	QrJ6FpLVs5CsWMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJLakdjCubLA4xCjAwajE
	w6vZeiVAiDWxrLgy9xCjBAezkgiv/zygEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJJucD4z6v
	JN7Q2NjEzMTUxNzS1NwUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsbK1LnZMi8bVxss
	ZzNb35fdIZWzR/ml+Zt3sU9ufYy3L43wPLKxMlch8v364spbfR+VVnbqzmoInBjdVyPRxLKq
	fNqnvwU8UUopug0yq3/wms4NC7mrc+aQZGxdNAuX2UOb3JOh+qp75D4vuXFdJPNuaZBmrMmL
	L31nX3hNVEw0Mw/6k6B0XYmlOCPRUIu5qDgRAJfiWvvaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQd2ny64EGLx8ZmNxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM37fvcJWsEm04sfaXcwN
	jO8Euhg5OSQETCR65vSxQdhiEhfurQeyuTiEBKYzSuzZeIIZwpnHJLG54wArSBWbgIbE4ffP
	2EFsEQE1ica/nawgRcwCH5kkbj3aygySEBKolDj/Zw9TFyMHB6eAk8TJWTEgYWEBL4l9Dycx
	gdgsAqoSN18tAivhFbCU+HuvAiTMKyAo8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khDlWQ2HH2
	NSPECVYSVxetZYOoEZeY9OAh+wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iREcuc+kdjCubLA4xCjAwajEw6vZeiVAiDWxrLgy9xCjBAezkgiv/zygEG9K
	YmVValF+fFFpTmrxIUYfoEcnMkuJJucDk0peSbyhsYmZkaWRmYWRibk5DmElcd5mj5QAIYH0
	xJLU7NTUgtQimHFMHJxSDYwmlXYeGe1GIbc2eDOerf9y7LErr4yUVxe/etUz61MBzNIWe97e
	OuG9KFbZuSVhh/AOLdGwuTJtqfmJ2frfw3IufP+SOXm6zUlGC3Wv+6pXi2OnHe+6kXzRJ7N7
	xZ+N8tu54m6Zv/10ft+KIz+rVWftW9RkbBsyN2/a0of2fU+uVHXUiD99fFaJpTgj0VCLuag4
	EQDZINCsCQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongjin Kim wrote:
> 
> Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412
> SoC.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/boot/dts/Makefile               |    1 +
>  arch/arm/boot/dts/exynos4412-odroidx.dts |   47
> ++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos4412-odroidx.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index d077ef8..364d67b 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -44,6 +44,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-
> origen.dtb \
>  	exynos4210-trats.dtb \
>  	exynos5250-smdk5250.dtb \
>  	exynos5440-ssdk5440.dtb \
> +	exynos4412-odroidx.dtb \
>  	exynos4412-smdk4412.dtb \
>  	exynos5250-smdk5250.dtb \
>  	exynos5250-snow.dtb

Just now, I sorted out the ordering alphabetically and submitted.

> diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts
> b/arch/arm/boot/dts/exynos4412-odroidx.dts
> new file mode 100644
> index 0000000..323ed177
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
> @@ -0,0 +1,47 @@
> +/*
> + * Hardkernel's Exynos4412 based ODROID-X board device tree source
> + *
> + * Copyright (c) 2012 Dongjin Kim <tobetter@gmail.com>
> + *
> + * Device tree source file for Hardkernel's ODROID-X board which is based
> on
> + * Samsung's Exynos4412 SoC.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +/dts-v1/;
> +/include/ "exynos4412.dtsi"
> +
> +/ {
> +	model = "Hardkernel ODROID-X board based on Exynos4412";
> +	compatible = "hardkernel,exynos4412", "samsung,exynos4412";

Probably, 

+	compatible = "hardkernel,odroid-x", "samsung,exynos4412";

> +
> +	memory {
> +		reg = <0x40000000 0x40000000>;

If you can't see any error message in kernel boot, boot-loader should inform
the memory size and bank information to the kernel. So should be separated
with bank size, 256MiB. But I need to think again as Olof said in other
thread.

> +	};
> +
> +	serial@13800000 {
> +		status = "okay";
> +	};
> +
> +	serial@13810000 {
> +		status = "okay";
> +	};
> +
> +	serial@13820000 {
> +		status = "okay";
> +	};
> +
> +	serial@13830000 {
> +		status = "okay";
> +	};
> +
> +	sdhci@12530000 {
> +		bus-width = <4>;
> +		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
> +		pinctrl-names = "default";
> +		status = "okay";
> +	};
> +};
> --
> 1.7.9.5

BTW, you don't need any bootargs as default?

- Kukjin

