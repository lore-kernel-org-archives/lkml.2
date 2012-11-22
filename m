Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279Ab2KVTxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:53:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32887 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248Ab2KVTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:53:15 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-fd-50ad830c13ed
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Will Newton'" <will.newton@imgtec.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
 <1353535387-32106-2-git-send-email-dianders@chromium.org>
In-reply-to: <1353535387-32106-2-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH 2/2] mmc: dw_mmc: Handle wp-gpios from device tree
Date: Thu, 22 Nov 2012 10:42:35 +0900
Message-id: <000701cdc852$a5e4a130$f1ade390$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3INAdNVvHLrPfxQG2AArjr+cP+EwAGlCrA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zI12e5rUBBsc3CVtc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlbHj2wG2gkPSFQd/LWNuYDwn2sXIySEhYCKx
	ZtVCNghbTOLCvfVANheHkMAyRomWrw+ZYIqW7O9igUhMZ5SYNvs0O0hCSOAPo8T5DX4gNpuA
	lsTfN2+YQYpEQLo3rmsBc5gFvgF1XL0ANbeRUeJcezcjSAungJvE7gMvwWxhIHv10ZVgNouA
	qsT1i3uAujk4eAVsJdY15YKEeQUEJX5MvscCYjMLGEi8n9XHCmHLS2xe8xasXEJAXeLRX12Q
	sIiAkcTJk6+YIEpEJPa9eAc1XUDi2+RDLBDlshKbDoCdKSGwiV3izL770KCQlDi44gbLBEaJ
	WUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIyTipHYwrmywOMQo
	wMGoxMOr6bw2QIg1say4MvcQowQHs5II76ICoBBvSmJlVWpRfnxRaU5q8SFGH6DLJzJLiSbn
	A5NBXkm8obGxiZmJqYm5pam5KQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2MLvs+SXS4
	f/0gK9Wyb/HE2b1qjn8nh9xs2ZfgtPmTUMhPhs0HPQJdt2eF1e8V9q52dD/2WHau0mZOtmO2
	H09yrLG9ob9m7qEYtsP5u9v8lVpLU2pz58l9t7nX+Nm+ct+c5s9mTW3yzfV7D/MITnnaknw+
	oFZNNHujoXPOxS3Nep8q792pbt+gxFKckWioxVxUnAgAkjhspOUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoC5P89oAgx+/+Swu75rDZnHkfz+j
	xYzz+5gcmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zY8e0A
	W8Eh6YqDv5YxNzCeE+1i5OSQEDCRWLK/iwXCFpO4cG89WxcjF4eQwHRGiWmzT7ODJIQE/jBK
	nN/gB2KzCWhJ/H3zhhmkSERgGaPExnUtYA6zwDegjqsXoNobGSXOtXczgrRwCrhJ7D7wEswW
	BrJXH10JZrMIqEpcv7gHqJuDg1fAVmJdUy5ImFdAUOLH5HtgJzELGEi8n9XHCmHLS2xe8xas
	XEJAXeLRX12QsIiAkcTJk6+YIEpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBMfzM6kdjCsbLA4xCnAwKvHwajqvDRBiTSwrrsw9xCjBwawk
	wruoACjEm5JYWZValB9fVJqTWnyI0Qfoz4nMUqLJ+cBUk1cSb2hsYmZkaWRmYWRibo5DWEmc
	t9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDI7PILKmGeZumhG10slJM/PY+67nG7++9t7sff3u1
	/HxMt0v7gaPbLp0651BZL1eal+VXpXGD7XjdOc7dd6u5577Z7bZpY/NpK1YRrWDB2eds6iLZ
	L3htd8gIjfXzSft5eNa5m21/Fm2TzUkLX7d89QKGZ2KWf+NleXf6LBKI+5C66DtL5ap9HEos
	xRmJhlrMRcWJAKyTqAoUAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

wp-gpios has been implemented in dw_mmc-exynos.c
It can be reused for EXYNOS platform? We need to modify some though.

Thanks,
Seungwon Jeon

On Thursday, November 22, 2012, Doug Anderson <dianders@chromium.org> wrote:
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
> --
> 1.7.7.3

