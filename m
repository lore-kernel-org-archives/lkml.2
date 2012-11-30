Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2K3L5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:57:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19551 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2K3L5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:57:07 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-16-50b89f11d239
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, linux-mmc@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Will Newton'" <will.newton@imgtec.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Rob Landley'" <rob@landley.net>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
References: <1353624835-19137-1-git-send-email-dianders@chromium.org>
 <1354251857-21587-1-git-send-email-dianders@chromium.org>
In-reply-to: <1354251857-21587-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v3 1/4] mmc: dw_mmc: Add "disable-wp" device tree property
Date: Fri, 30 Nov 2012 20:57:04 +0900
Message-id: <001601cdcef1$d0c9d1e0$725d75a0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3OuMniS+W5eVkCSL6NxqXWlSBUJQAOA/iA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zA13B+TsCDDovilssbFvCYnF51xw2
	iyP/+xktZpzfx+TA4vF5k1wAYxSXTUpqTmZZapG+XQJXxsaOZewFW/UrDh5Yw9TAeEm1i5GT
	Q0LAROJu8z42CFtM4sK99WC2kMAyRonlS4W7GDnAaqZ2qHcxcgGFFzFKvDs1kRHC+cMoMeXg
	AyaQBjYBLYm/b94wg9giAm4SB38dBitiFtjHIvHyzyKoqY2MEp9OuoHYnEBFz641gDUIC/hJ
	9DSuZQPZxiKgKrH/bgyIyStgK3HpmzJIBa+AoMSPyfdYQGxmAQOJ97P6WCFseYnNa94yQ9yp
	LvHory7EBUYSDS96mCBKRCT2vXjHCGKzCAhIfJt8iAWiXFZi0wFmiM/3sUtcaMuEsCUlDq64
	wTKBUWIWksWzkCyehWTxLCQbFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIiTipHYwr
	GywOMQpwMCrx8G7YsD1AiDWxrLgy9xCjBAezkgjvPsEdAUK8KYmVValF+fFFpTmpxYcYfYAO
	n8gsJZqcD0wGeSXxhsbGJmYmpibmlqbmpjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUw
	dn+etP/RPNusB7EnFbKENs3m4Pb4Yj//7wuxbcxdrbc2/L4Xuqrc1/hFgkW9ih/PJvOM+bGL
	7rbYiB2ZtOdjWSP33/P92zkO9jmlbrVc9FlXdP3JwmXbFh/t0Zw7+dmtMpH766q+VT3ZYZrf
	+W8zz/RTu1U4Zz2enzYrclZmrdWPnU/up/2O+aXEUpyRaKjFXFScCAAMRUYk5QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgK7g/B0BBh+mClgsbFvCYnF51xw2
	iyP/+xktZpzfx+TA4vF5k1wAY1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEd
	Y8bGjmXsBVv1Kw4eWMPUwHhJtYuRg0NCwERiaod6FyMnkCkmceHeerYuRi4OIYFFjBLvTk1k
	hHD+MEpMOfiACaSKTUBL4u+bN8wgtoiAm8TBX4fBipgF9rFIvPyziA0kISTQyCjx6aQbiM0J
	VPTsWgNYg7CAn0RP41o2kM0sAqoS++/GgJi8ArYSl74pg1TwCghK/Jh8jwXEZhYwkHg/q48V
	wpaX2LzmLTPEzeoSj/7qQlxgJNHwoocJokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEw/k9rBuLLB4hCjAAejEg/vhg3bA4RYE8uKK3MP
	MUpwMCuJ8O4T3BEgxJuSWFmVWpQfX1Sak1p8iNEH6M2JzFKiyfnAdJNXEm9obGJmZGlkZmFk
	Ym6OQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA6N1b8Y9a8GJNon/CiZIfE8srDM/ts5I
	7++yYrW4WfOnn91zy3GO1l5lpnX5/x818/RzdR8IqGLPk5j2cZ1nul3WFItdcyRXL35s6/S0
	y6kr4f7OoH3mirL/A/U5jy+UT1b/Vm75cVfOw/s3457OvH+lVyZ8+nT/0/e43FWLy2ewxJwO
	UPJ9s1KJpTgj0VCLuag4EQACnW83FgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug, Thanks to work.
Looks good to me with other patches.

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

On Friday, November 30, 2012, Doug Anderson wrote:
> The "disable-wp" property is used to specify that a given SD card slot
> doesn't have a concept of write protect.  This eliminates the need for
> special case code for SD slots that should never be write protected
> (like a micro SD slot or a dev board).
> 
> The dw_mmc driver is special in needing to specify "disable-wp"
> because the lack of a "wp-gpios" property means to use the special
> purpose write protect line.  On some other mmc devices the lack of
> "wp-gpios" means that write protect should be disabled.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3:
> - New for this version of the patch series.  Chose "disable-wp" rather
>   than the discussed "broken-internal-wp" since it mapped more cleanly
>   to an existing quirk (and the only reason to specify that the
>   internal wp is broken is if you're disabling the write protect
>   anyway).
> 
>  .../devicetree/bindings/mmc/synopsis-dw-mshc.txt   |   12 +++++-
>  drivers/mmc/host/dw_mmc.c                          |   36 +++++++++++++++++++-
>  include/linux/mmc/dw_mmc.h                         |    4 ++
>  3 files changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> index 06cd32d08..726fd21 100644
> --- a/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> +++ b/Documentation/devicetree/bindings/mmc/synopsis-dw-mshc.txt
> @@ -26,8 +26,16 @@ Required Properties:
>  	* bus-width: as documented in mmc core bindings.
> 
>  	* wp-gpios: specifies the write protect gpio line. The format of the
> -	  gpio specifier depends on the gpio controller. If the write-protect
> -	  line is not available, this property is optional.
> +	  gpio specifier depends on the gpio controller. If a GPIO is not used
> +	  for write-protect, this property is optional.
> +
> +	* disable-wp: If the wp-gpios property isn't present then (by default)
> +	  we'd assume that the write protect is hooked up directly to the
> +	  controller's special purpose write protect line (accessible via
> +	  the WRTPRT register).  However, it's possible that we simply don't
> +	  want write protect.  In that case specify 'disable-wp'.
> +	  NOTE: This property is not required for slots known to always
> +	  connect to eMMC or SDIO cards.
> 
>  Optional properties:
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 7342029..b47b1e9 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -74,6 +74,7 @@ struct idmac_desc {
>   * struct dw_mci_slot - MMC slot state
>   * @mmc: The mmc_host representing this slot.
>   * @host: The MMC controller this slot is using.
> + * @quirks: Slot-level quirks (DW_MCI_SLOT_QUIRK_XXX)
>   * @ctype: Card type for this slot.
>   * @mrq: mmc_request currently being processed or waiting to be
>   *	processed, or NULL when the slot is idle.
> @@ -88,6 +89,8 @@ struct dw_mci_slot {
>  	struct mmc_host		*mmc;
>  	struct dw_mci		*host;
> 
> +	int			quirks;
> +
>  	u32			ctype;
> 
>  	struct mmc_request	*mrq;
> @@ -828,7 +831,8 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
>  	struct dw_mci_board *brd = slot->host->pdata;
> 
>  	/* Use platform get_ro function, else try on board write protect */
> -	if (brd->quirks & DW_MCI_QUIRK_NO_WRITE_PROTECT)
> +	if ((brd->quirks & DW_MCI_QUIRK_NO_WRITE_PROTECT) ||
> +	    (slot->quirks & DW_MCI_SLOT_QUIRK_NO_WRITE_PROTECT))
>  		read_only = 0;
>  	else if (brd->get_ro)
>  		read_only = brd->get_ro(slot->id);
> @@ -1788,6 +1792,30 @@ static struct device_node *dw_mci_of_find_slot_node(struct device *dev, u8 slot)
>  	return NULL;
>  }
> 
> +static struct dw_mci_of_slot_quirks {
> +	char *quirk;
> +	int id;
> +} of_slot_quirks[] = {
> +	{
> +		.quirk	= "disable-wp",
> +		.id	= DW_MCI_SLOT_QUIRK_NO_WRITE_PROTECT,
> +	},
> +};
> +
> +static int dw_mci_of_get_slot_quirks(struct device *dev, u8 slot)
> +{
> +	struct device_node *np = dw_mci_of_find_slot_node(dev, slot);
> +	int quirks = 0;
> +	int idx;
> +
> +	/* get quirks */
> +	for (idx = 0; idx < ARRAY_SIZE(of_slot_quirks); idx++)
> +		if (of_get_property(np, of_slot_quirks[idx].quirk, NULL))
> +			quirks |= of_slot_quirks[idx].id;
> +
> +	return quirks;
> +}
> +
>  /* find out bus-width for a given slot */
>  static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>  {
> @@ -1803,6 +1831,10 @@ static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>  	return bus_wd;
>  }
>  #else /* CONFIG_OF */
> +static int dw_mci_of_get_slot_quirks(struct device *dev, u8 slot)
> +{
> +	return 0;
> +}
>  static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
>  {
>  	return 1;
> @@ -1831,6 +1863,8 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>  	slot->host = host;
>  	host->slot[id] = slot;
> 
> +	slot->quirks = dw_mci_of_get_slot_quirks(host->dev, slot->id);
> +
>  	mmc->ops = &dw_mci_ops;
>  	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 510);
>  	mmc->f_max = host->bus_hz;
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index 34be4f4..24dc3a8 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -212,6 +212,10 @@ struct dw_mci_dma_ops {
>  /* Write Protect detection not available */
>  #define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
> 
> +/* Slot level quirks */
> +/* This slot has no write protect */
> +#define DW_MCI_SLOT_QUIRK_NO_WRITE_PROTECT	BIT(0)
> +
>  struct dma_pdata;
> 
>  struct block_settings {
> --
> 1.7.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

