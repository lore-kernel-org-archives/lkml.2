Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2AaGZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:25:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34970 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2AaGZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:25:08 -0500
X-AuditID: cbfee61a-b7cd2ae000004fa5-80-4f2789424e53
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Greg KH'" <gregkh@suse.de>
References: 
In-reply-to: 
Subject: RE: [PATCH] serial: samsung: Add support serial for EXYNOS4212 and
 EXYNOS4412
Date: Tue, 31 Jan 2012 15:25:04 +0900
Message-id: <042101ccdfe1$11ec0d60$35c42820$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczclWaEzxcCP5D8S+m5SusHDXnFWgCofZSQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> 
> This should be added for EXYNOS4212 and EXYNOS4412 SoCs.
> 
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: stable@kerne.org

Oops, should be 'Cc: stable@kernel.org'

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  drivers/tty/serial/samsung.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index f96f37b..ce632da 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -1593,7 +1593,8 @@ static struct s3c24xx_serial_drv_data
s5pv210_serial_drv_data = {
>  #define S5PV210_SERIAL_DRV_DATA	(kernel_ulong_t)NULL
>  #endif
> 
> -#ifdef CONFIG_CPU_EXYNOS4210
> +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS4212) || \
> +	defined(CONFIG_CPU_EXYNOS4412)
>  static struct s3c24xx_serial_drv_data exynos4210_serial_drv_data = {
>  	.info = &(struct s3c24xx_uart_info) {
>  		.name		= "Samsung Exynos4 UART",
> --
> 1.7.1


