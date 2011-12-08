Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1LHA2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:28:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15191 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab1LHA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:28:52 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-4f-4ee004c3b792
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
 <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1323275041-25493-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1323275041-25493-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 2/4] gpio: Fix typo in comment in Samsung driver
Date: Thu, 08 Dec 2011 09:28:51 +0900
Message-id: <04c501ccb540$5c0d6d60$14284820$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy0/MldZALa5CAFTmGkbEKtAzbcOQAQ3bKQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> ---
>  drivers/gpio/gpio-samsung.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index f1c1ecd..f44c020 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -233,7 +233,7 @@ static int samsung_gpio_setcfg_2bit(struct samsung_gpio_chip *chip,
>   * @chip: The gpio chip that is being configured.
>   * @off: The offset for the GPIO being configured.
>   *
> - * The reverse of samsung_gpio_setcfg_2bit(). Will return a value whicg
> + * The reverse of samsung_gpio_setcfg_2bit(). Will return a value which
>   * could be directly passed back to samsung_gpio_setcfg_2bit(), from the
>   * S3C_GPIO_SPECIAL() macro.
>   */
> --
> 1.7.7.3

