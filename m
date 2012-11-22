Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2KVUGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:06:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11104 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2KVUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:06:13 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-bd-50ad8633d6f2
Message-id: <50AD862D.40302@samsung.com>
Date: Thu, 22 Nov 2012 10:55:57 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc: dw_mmc: Handle wp-gpios from device tree
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
 <1353535387-32106-2-git-send-email-dianders@chromium.org>
In-reply-to: <1353535387-32106-2-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zHV3jtrUBBjtvWltc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlbH+yy32glnSFSe2tTE1MC4S7WLk5JAQMJE4
	07STGcIWk7hwbz1bFyMXh5DAMkaJAxtOMMIU7V62hR3EFhJYxCjRP1kZouglo8S6eS+YQBK8
	AhoSDScugNksAqoSi3ZdBmtmE9CR2P7tOFCcg0NUIExi5+Z0iHJBiR+T77GA2CICmhLPGl4y
	g8xkFnjIJNHT/JoNJCEs4CbR2HGXEWJZI6PEufZusKGcQIndB16C2cxAC/a3TmODsOUlNq95
	ywxxhIDEt8mHWEAWSwjISmw6ALZAQmAyu0TDlQ4WiM8kJQ6uuMEygVFsFpKjZiEZOwvJ2AWM
	zKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxQiJFagfjygaLQ4wCHIxKPLyazmsDhFgTy4or
	cw8xSnAwK4nwLioACvGmJFZWpRblxxeV5qQWH2L0Abp2IrOUaHI+MIrzSuINjQ2MDQ0tDc1M
	LU0NcAgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamDkXqpxf/YbJjfG2k9cvgv78ydW/5qy
	UenhJcbVBi/1viwtFL24RCPIMtLhyNftfscNZnzimDSxoWHC1MM7u9+d2XM6Stjn0COVPV9i
	N8jeOFx7Q3xmqb7MHnHDNaubTiwPjAu45LXQ+5LKjVk7g5wj5PT1Fu3uU77dxCBV0fGwb0rP
	Xfu0s1q7lViKMxINtZiLihMBGrYYnMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAV3jtrUBBicvGltc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ix/sst
	9oJZ0hUntrUxNTAuEu1i5OSQEDCR2L1sCzuELSZx4d56NhBbSGARo0T/ZOUuRi4g+yWjxLp5
	L5hAErwCGhINJy6A2SwCqhKLdl1mBLHZBHQktn87DhTn4BAVCJPYuTkdolxQ4sfkeywgtoiA
	psSzhpfMIDOZBR4ySfQ0vwZbJizgJtHYcZcRYlkjo8S59m6woZxAid0HXoLZzEAL9rdOY4Ow
	5SU2r3nLPIFRYBaSJbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAcPpPa
	wbiyweIQowAHoxIPr6bz2gAh1sSy4srcQ4wSHMxKIryLCoBCvCmJlVWpRfnxRaU5qcWHGH2A
	QTCRWUo0OR+YIvJK4g2NTcyMLI3MjE3MjY1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRq
	YDTba9qh+0985R4m1sbj+xU2q5X82ShiJh9+Q9Tif5xvT0nt4+uPBFKP/LQMXuXUXbPh6bYL
	8Q1avVLfWt5rmC3b4jPJZ9eUaZW7xc9feND41Pxk98tdGnqqrx4uPzuXPenMs/sz9Bx0zL56
	3mlX/rprez2TTdmJzcELFj63/tQ2p0flw/75e6yUWIozEg21mIuKEwEC3Lr/8AIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 07:03 AM, Doug Anderson wrote:
> On some SoCs (like exynos5250) you need to use an external GPIO for
> write protect.  Add support for wp-gpios to the core dw_mmc driver
> since it could be useful across multiple SoCs.
> 
> With this change I am able to make use of the write protect for the
> external SD slot on exynos5250-snow.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 5b41348..9c79870 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -34,6 +34,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/workqueue.h>
>  #include <linux/of.h>
> +#include <linux/of_gpio.h>
>  
>  #include "dw_mmc.h"
>  
> @@ -74,6 +75,7 @@ struct idmac_desc {
>   * struct dw_mci_slot - MMC slot state
>   * @mmc: The mmc_host representing this slot.
>   * @host: The MMC controller this slot is using.
> + * @wp_gpio: If gpio_is_valid() we'll use this to read write protect.
>   * @ctype: Card type for this slot.
>   * @mrq: mmc_request currently being processed or waiting to be
>   *	processed, or NULL when the slot is idle.
> @@ -88,6 +90,8 @@ struct dw_mci_slot {
>  	struct mmc_host		*mmc;
>  	struct dw_mci		*host;
>  
> +	int			wp_gpio;
> +
>  	u32			ctype;
>  
>  	struct mmc_request	*mrq;
> @@ -832,6 +836,8 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
>  		read_only = 0;
>  	else if (brd->get_ro)
>  		read_only = brd->get_ro(slot->id);
> +	else if (gpio_is_valid(slot->wp_gpio))
> +		read_only = gpio_get_value(slot->wp_gpio);
>  	else
>  		read_only =
>  			mci_readl(slot->host, WRTPRT) & (1 << slot->id) ? 1 : 0;
> @@ -1802,6 +1808,29 @@ static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>  			       " as 1\n");
>  	return bus_wd;
>  }
> +
> +/* find the write protect gpio for a given slot; or -1 if none specified */
> +static u32 dw_mci_of_get_wp_gpio(struct device *dev, u8 slot)
> +{
> +	struct device_node *np = dw_mci_of_find_slot_node(dev, slot);
> +	int gpio;
> +
> +	if (!np)
> +		return -1;
I think good that use the error number instead of -1. Also the below code.

> +
> +	gpio = of_get_named_gpio(np, "wp-gpios", 0);
> +
> +	/* Having a missing entry is valid; return silently */
> +	if (!gpio_is_valid(gpio))
> +		return -1;
> +
> +	if (devm_gpio_request(dev, gpio, "dw-mci-wp")) {
> +		dev_warn(dev, "gpio [%d] request failed\n", gpio);
> +		return -1;
> +	}
> +
> +	return gpio;
gpio is int type, but return type is u32?

Best Regards,
Jaehoon Chung
> +}
>  #else /* CONFIG_OF */
>  static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>  {
> @@ -1811,6 +1840,10 @@ static struct device_node *dw_mci_of_find_slot_node(struct device *dev, u8 slot)
>  {
>  	return NULL;
>  }
> +static u32 dw_mci_of_get_wp_gpio(struct device *dev, u8 slot)
> +{
> +	return -1;
> +}
>  #endif /* CONFIG_OF */
>  
>  static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
> @@ -1923,6 +1956,8 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	else
>  		clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
>  
> +	slot->wp_gpio = dw_mci_of_get_wp_gpio(host->dev, slot->id);
> +
>  	mmc_add_host(mmc);
>  
>  #if defined(CONFIG_DEBUG_FS)
> 

