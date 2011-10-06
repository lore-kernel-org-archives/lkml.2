Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935320Ab1JFFYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:24:51 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:8596 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab1JFFYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:24:49 -0400
Message-ID: <4E8D3B9D.6030208@dsn.lapis-semi.com>
Date: Thu, 06 Oct 2011 14:24:45 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
CC: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        tomoya-linux@dsn.okisemi.com
Subject: Re: [PATCH] spi_topcliff_pch: supports a spi mode setup and bit order
 setup by IO control
References: <1311141414-12867-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
In-Reply-To: <1311141414-12867-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

It seems this patch Toshiharu posted in 20-July remains not to be
reviewed by you.

Could you review this patch and merge to your tree ?

Thanks in advance,

-- 
tomoya
ROHM Co., Ltd.

(2011/07/20 14:56), Toshiharu Okada wrote:
> This patch supports a spi mode setup and bit order setup by IO control.
>      spi mode:     mode 0 to mode 3
>      bit order:    LSB first, MSB first
> 
> Signed-off-by: Toshiharu Okada<toshiharu-linux@dsn.okisemi.com>
> ---
>   drivers/spi/spi_topcliff_pch.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
> index 79e48d4..dec83c9 100644
> --- a/drivers/spi/spi_topcliff_pch.c
> +++ b/drivers/spi/spi_topcliff_pch.c
> @@ -1038,6 +1038,7 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	master->num_chipselect = PCH_MAX_CS;
>   	master->setup = pch_spi_setup;
>   	master->transfer = pch_spi_transfer;
> +	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
>   	dev_dbg(&pdev->dev,
>   		"%s transfer member of SPI master initialized\n", __func__);
> 


