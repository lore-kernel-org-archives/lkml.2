Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2KUJnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:43:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41742 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2KUJnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:43:08 -0500
X-AuditID: cbfee61b-b7f616d00000319b-21-50aca228bff6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353450428-2615-1-git-send-email-dianders@chromium.org>
In-reply-to: <1353450428-2615-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH 1/2] ARM: EXYNOS: Add aliases for i2c controller for exynos4
Date: Wed, 21 Nov 2012 18:43:04 +0900
Message-id: <0dfb01cdc7cc$9aa39500$cfeabf00$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HbkfixzB/PV60R4OkgDtjkt7UJgAOWEcg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zfV2NRWsCDBpb9C06/n5htLi8aw6b
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgymj4MZe94LloxeQrl1gbGGcLdDFyckgImEjc
	+3+HGcIWk7hwbz1bFyMXh5DAMkaJY1euMsEUdV9sYIVITGeU+PtqDjuE85dR4s6cfrAqNgEN
	icPvn7GD2CICfhJHn+9gAiliFtjCJHH4yn+wHUICLhKrT70FSnBwcAq4Sqw/rgUSFhYIkNi8
	4CcbiM0ioCrx88Q+MJtXwFbiwKVljBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBhkpIaAu
	8eivLogpImAkMXEOF0SFiMS+F+8YIaYLSHybfIgFolpWYtMBZpAjJQS2sUtMaXsPDQhJiYMr
	brBMYJSYhWTxLCSLZyFZPAvJigWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxQqJNegfj
	qgaLQ4wCHIxKPLwS+1YHCLEmlhVX5h5ilOBgVhLh3TRlTYAQb0piZVVqUX58UWlOavEhRh+g
	yycyS4km5wMTQV5JvKGxsYmZiamJuaWpuSkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFIN
	jKpJh7kErvlerX1jES22a28z/y0bjQjHtyGCRhOZeW9VVyqKehuorA05fOJeXXLRwY5gq4Mf
	GbnMTGO9eDNtGC/43t+ay1EWHKvS+9bk5C4XNYZf9gJ7O0tcKqTb7jbd3S0bcTjx/mNzHa6/
	Ow3/cCkZRZZosGc+27wh+MadT86vt817+qFaiaU4I9FQi7moOBEA0l3vWuMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jQV2NRWsCDHZO0bbo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjGj4cdc
	9oLnohWTr1xibWCcLdDFyMkhIWAi0X2xgRXCFpO4cG89WxcjF4eQwHRGib+v5rBDOH8ZJe7M
	6WcCqWIT0JA4/P4ZO4gtIuAncfT5DiaQImaBLUwSh6/8ZwZJCAm4SKw+9RYowcHBKeAqsf64
	FkhYWCBAYvOCn2wgNouAqsTPE/vAbF4BW4kDl5YxQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe
	85YZZKSEgLrEo7+6IKaIgJHExDlcEBUiEvtevGOcwCg0C8mgWUgGzUIyaBaSlgWMLKsYRVML
	kguKk9JzjfSKE3OLS/PS9ZLzczcxgmP5mfQOxlUNFocYBTgYlXh4JfatDhBiTSwrrsw9xCjB
	wawkwrtpypoAId6UxMqq1KL8+KLSnNTiQ4w+QH9OZJYSTc4Hppm8knhDYxMzI0sjMwsjE3Nz
	HMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhi3pgYxCIs+eTD9pI5TEfu7s++nGHLF6G62
	SVXec0eEeQJ/0Lxk/x9rODqObt9l3hG6WJqv12wnh/Leb90X597y/r3rX7dHTnqfX0bMYauH
	nrVa9dJaLtE/A4oF00vLOxStjZ46dVzPrpto/y3FPai3fqF3ZKr7al7ft9Hb5z/4+O1p7uMt
	m5VYijMSDbWYi4oTAeyDNJISAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> This is similar to a recent commit for exynos5250 titled:
>   ARM: EXYNOS: Add aliases for i2c controller
> 
> Adding aliases will be useful to prevent warnings in a future
> change.  See:
>   i2c: s3c2410: Get the i2c bus number from alias id
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> ---
>  arch/arm/boot/dts/exynos4.dtsi |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4.dtsi
> b/arch/arm/boot/dts/exynos4.dtsi
> index a26c3dd..824d362 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -28,6 +28,14 @@
>  		spi0 = &spi_0;
>  		spi1 = &spi_1;
>  		spi2 = &spi_2;
> +		i2c0 = &i2c_0;
> +		i2c1 = &i2c_1;
> +		i2c2 = &i2c_2;
> +		i2c3 = &i2c_3;
> +		i2c4 = &i2c_4;
> +		i2c5 = &i2c_5;
> +		i2c6 = &i2c_6;
> +		i2c7 = &i2c_7;
>  	};
> 
>  	gic:interrupt-controller@10490000 {
> @@ -121,7 +129,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@13860000 {
> +	i2c_0: i2c@13860000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> @@ -130,7 +138,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@13870000 {
> +	i2c_1: i2c@13870000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> @@ -139,7 +147,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@13880000 {
> +	i2c_2: i2c@13880000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> @@ -148,7 +156,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@13890000 {
> +	i2c_3: i2c@13890000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> @@ -157,7 +165,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@138A0000 {
> +	i2c_4: i2c@138A0000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> @@ -166,7 +174,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@138B0000 {
> +	i2c_5: i2c@138B0000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> @@ -175,7 +183,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@138C0000 {
> +	i2c_6: i2c@138C0000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> @@ -184,7 +192,7 @@
>  		status = "disabled";
>  	};
> 
> -	i2c@138D0000 {
> +	i2c_7: i2c@138D0000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "samsung,s3c2440-i2c";
> --
> 1.7.7.3

Applied, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

