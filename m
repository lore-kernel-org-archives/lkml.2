Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2KVTAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:00:46 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58188 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab2KVTAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:00:41 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0a-50adcb32c4f3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org, "'Olof Johansson'" <olof@lixom.net>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353451739-6317-1-git-send-email-dianders@chromium.org>
 <1353516865-2502-1-git-send-email-dianders@chromium.org>
In-reply-to: <1353516865-2502-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v2] ARM: exynos: add UART3 to DEBUG_LL ports
Date: Thu, 22 Nov 2012 15:50:26 +0900
Message-id: <0f5a01cdc87d$a7326f60$f5974e20$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ICXP/3XPpRvMkQLW/cWMt70nLXAAbiekQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI12j02sDDI6ss7G4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrYNIevYAl/xbtdJ9gbGHt5uhg5OSQETCT6T71ng7DF
	JC7cWw9kc3EICSxjlDg65wczTNHPO3fYQWwhgemMEp8WikEU/WWUuDznIlgRm4CGxOH3z8CK
	RASKJVr/bmcGKWIWOMIoce3OWiaI7nqJKzPWghVxCrhKdC/5DGYLCzhIbG/9AWazCKhKHH52
	mxHE5hWwlfjUMI0ZwhaU+DH5HguIzSygJbF+53EmCFteYvOat0A1HECXqks8+qsLcYORxNG+
	tVAlIhL7XrxjhBgvIPFt8iEWiHJZiU0HwM6UEFjGLvF06iaohyUlDq64wTKBUWIWks2zkGye
	hWTzLCQrFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIiTHpHYyrGiwOMQpwMCrx8GYY
	rA0QYk0sK67MPcQowcGsJMK7qAAoxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnA+M8riTc0
	NjYxMzE1Mbc0NTfFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgXGD20/l/PgKtgUMqVLt
	vsbNLKd2nvHcdPm5xUe5yZ+3WcyJXeUbY+b1lrE6/S/jTWuJSM2WGefEReWqmh/GlPB/1gq/
	sCzy3SXRxcFvft3Va/pzsdwrV+r2gb+d5wxusD6RDOCaa7y67Ma50zN2zPv59kpsA7+ngM3e
	4Eq1kKmmq9niGe89q1RiKc5INNRiLipOBADQyp353gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQV2j02sDDGactrC4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2DSHr2AJf8W7
	XSfYGxh7eboYOTkkBEwkft65ww5hi0lcuLeeDcQWEpjOKPFpoVgXIxeQ/ZdR4vKci8wgCTYB
	DYnD75+BNYgIFEu0/t3ODFLELHCEUeLanbVMEN31EldmrAUr4hRwlehe8hnMFhZwkNje+gPM
	ZhFQlTj87DYjiM0rYCvxqWEaM4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+BajiALlWXePRX
	F+IGI4mjfWuhSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIER/Az6R2MqxosDjEKcDAq8fBmGKwNEGJNLCuuzD3EKMHBrCTCu6gAKMSbklhZ
	lVqUH19UmpNafIjRB+jRicxSosn5wOSSVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEk
	NTs1tSC1CGYcEwenVANj4rMHu9sZ3E8EL/e/7vv85ztLoSDxX7WPORPKl6ldzrNZb3RCz+tJ
	zYlYAfvw6XazEzLV5B9UXTYKfS82e61jYssLtYvVmSdP77uzSPOvv0RP9Jsb/r//zJRvbf5U
	aB7y7n2GZZlZefpq1e1LmXam7LR97+S2dRWLl07D7F8Ti2ctmLkgJ7lciaU4I9FQi7moOBEA
	voxsdQ0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> From: Olof Johansson <olof@lixom.net>
> 
> Add support for using UART3 for DEBUG_LL on exynos.
> 
> [dianders: added depend on ARCH_EXYNOS.]
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> ---
> Changes in v2:
> - Matched Olof's commit message.
> - Added ARCH_EXYNOS to depend list.
> 
>  arch/arm/Kconfig.debug        |   11 +++++++++++
>  arch/arm/plat-samsung/Kconfig |    1 +
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 33a8930..f54f170 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -355,6 +355,17 @@ choice
>  		  The uncompressor code port configuration is now handled
>  		  by CONFIG_S3C_LOWLEVEL_UART_PORT.
> 
> +	config DEBUG_S3C_UART3
> +		depends on PLAT_SAMSUNG && ARCH_EXYNOS
> +		bool "Use S3C UART 3 for low-level debug"
> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to UART 3. The port must have been
initialised
> +		  by the boot-loader before use.
> +
> +		  The uncompressor code port configuration is now handled
> +		  by CONFIG_S3C_LOWLEVEL_UART_PORT.
> +
>  	config DEBUG_SOCFPGA_UART
>  		depends on ARCH_SOCFPGA
>  		bool "Use SOCFPGA UART for low-level debug"
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 59401e1..d342ed0 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -502,5 +502,6 @@ config DEBUG_S3C_UART
>  	default "0" if DEBUG_S3C_UART0
>  	default "1" if DEBUG_S3C_UART1
>  	default "2" if DEBUG_S3C_UART2
> +	default "3" if DEBUG_S3C_UART3
> 
>  endif
> --
> 1.7.7.3

Applied, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

