Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab2GZEAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 00:00:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56085 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2GZEAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 00:00:42 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-c8-5010c0e0c1d1
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, "'Will Newton'" <will.newton@imgtec.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        linux-kernel@vger.kernel.org,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Olof Johansson'" <olofj@chromium.org>, shashidharh@vayavyalabs.com,
        ki0351.kim@samsung.com
References: <CAD=FV=V0Z=f+DNZKnaX9cJqS3MTmPdF8G3wmbYJYW34bUZqoXg@mail.gmail.com>
 <1343230397-10500-1-git-send-email-dianders@chromium.org>
In-reply-to: <1343230397-10500-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v4] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
Date: Thu, 26 Jul 2012 13:00:31 +0900
Message-id: <000501cd6ae3$33beb8b0$9b3c2a10$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1qet/7vUIl3cmESuK83ZRiAyFcvgAR6cBg
Content-language: ko
x-cr-hashedpuzzle: Fbj6 WzWF nwMU xOga x/j+ x/6N ywKa 8XtG AAa1EA== AA1xTQ==
 ABJvcQ== AEDQZg== AEU8Yg== AI070Q== AI32dQ==
 AJvt2A==;11;YwBqAGIAQABsAGEAcAB0AG8AcAAuAG8AcgBnADsAZABpAGEAbgBkAGUAcgBzAEAAYwBoAHIAbwBtAGkAdQBtAC4AbwByAGcAOwBnAHIAdQBuAGQAbABlAHIAQABjAGgAcgBvAG0AaQB1AG0ALgBvAHIAZwA7AGoAYQBtAGUAcwAuAGgAbwBnAGEAbgBAAGkAbQBnAHQAZQBjAC4AYwBvAG0AOwBqAGgAOAAwAC4AYwBoAHUAbgBnAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAawBpADAAMwA1ADEALgBrAGkAbQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBtAG0AYwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbwBsAG8AZgBqAEAAYwBoAHIAbwBtAGkAdQBtAC4AbwByAGcAOwBzAGgAYQBzAGgAaQBkAGgAYQByAGgAQAB2AGEAeQBhAHYAeQBhAGwAYQBiAHMALgBjAG8AbQA7AHcAaQBsAGwALgBuAGUAdwB0AG8AbgBAAGkAbQBnAHQAZQBjAC4AYwBvAG0A;Sosha1_v1;7;{EDF7E94A-6B2C-43B1-B0E1-43AEB427B611};dABnAGkAaAAuAGoAdQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Thu,
 26 Jul 2012 04:00:15
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgAHYANABdACAAbQBtAGMAOgAgAGQAdwBfAG0AbQBjADoAIA
	BEAGkAcwBhAGIAbABlACAAbABvAHcAIABwAG8AdwBlAHIAIABtAG8AZABlACAAaQBmACAAUwBEAEkATwAgAGkAbgB0AGUAcgByAHUAcAB0AHMAIABhAHIAZQAgAHUAcwBlAGQA
x-cr-puzzleid: {EDF7E94A-6B2C-43B1-B0E1-43AEB427B611}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jQd0HBwQCDJa+lbS4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUsfPGRueC9YsXdpkamBsYbUl2MnBwSAiYSuxuXs0DY
	YhIX7q1n62Lk4hASmM4osfLbPWYI5w+jxOzmrawgVcICfhJNcyYxg9hsAloSf9+8AbNFBNwk
	Dv46zAjSwCxwkkniUmcDK0R3H6PEzs6p7CBVnEBVF69eZYeYFCnRv30z2G4WAVWJicsOgdm8
	ArYSl9o7GCFsQYkfk++BxZkFDCTez+pjhbDlJTaveQu0mQPobnWJR391IY4wkpixZzMbRImI
	xL4X78AOkhDo4ZQ4fXgvI0S9qcTPXvUJjKKzkGyYhWTDLCQbZiEZtYCRZRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcHw8k9rBuLLB4hCjAAejEg+vZ7hAgBBrYllxZe4hRgkOZiURXveV
	QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8xt5f/YUE0hNLUrNTUwtSi2CyTBycUg2M3c+2f+r2
	zNt0qiaywN1i2gmNH6cKyxsc1GeYBYgVfWV2m7fZ6JnklqVm5cIckQun/l4TZXiM6aH8iRc9
	DBe9/oW6/A6NcW/g+zv192yjIpU7wceYJy5R+PSo8YuezDOzBb+nZ1/i4hE8sz6RU3qLdkVK
	l0KMJ++jXffK3EWuyEtINrMwR2xVYinOSDTUYi4qTgQApjz2e4sCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

July 26, 2012, Doug Anderson <dianders@chromium.org> wrote:
> The documentation for the dw_mmc part says that the low power
> mode should normally only be set for MMC and SD memory and should
> be turned off for SDIO cards that need interrupts detected.
> 
> The best place I could find to do this is when the SDIO interrupt
> was first enabled.  I rely on the fact that dw_mci_setup_bus()
> will be called when it's time to reenable.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v4:
> - Don't regenerate slot variable when we already had it.
> 
> Changes in v3:
> - Commenting fixes requested by Seungwoon Jeon and Jaehoon Chung.
> - Only pass 'slot' to the low power disable function since whole mmc
>   structure wasn't needed.
> 
> Changes in v2:
> - Commenting fixes requested by Grant Grundler.
> - Be extra certain that we don't re-turn on the low power mode in
>   CLKENA in dw_mci_setup_bus() if SDIO interrupts are enabled.
>   There are no known instances of this happening but it's good to be safe.
> 
>  drivers/mmc/host/dw_mmc.c |   41 ++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 72dc3cd..882748b 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -627,6 +627,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot)
>  {
>  	struct dw_mci *host = slot->host;
>  	u32 div;
> +	u32 clk_en_a;
> 
>  	if (slot->clock != host->current_speed) {
>  		div = host->bus_hz / slot->clock;
> @@ -659,9 +660,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot)
>  		mci_send_cmd(slot,
>  			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
> 
> -		/* enable clock */
> -		mci_writel(host, CLKENA, ((SDMMC_CLKEN_ENABLE |
> -			   SDMMC_CLKEN_LOW_PWR) << slot->id));
> +		/* enable clock; only low power if no SDIO */
> +		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
> +		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
> +			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
> +		mci_writel(host, CLKENA, clk_en_a);
> 
>  		/* inform CIU */
>  		mci_send_cmd(slot,
> @@ -862,6 +865,30 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
>  	return present;
>  }
> 
> +/*
> + * Disable lower power mode.
> + *
> + * Low power mode will stop the card clock when idle.  According to the
> + * description of the CLKENA register we should disable low power mode
> + * for SDIO cards if we need SDIO interrupts to work.
> + *
> + * This function is fast if low power mode is already disabled.
> + */
> +static void dw_mci_disable_low_power(struct dw_mci_slot *slot)
> +{
> +	struct dw_mci *host = slot->host;
> +	u32 clk_en_a;
> +	const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
> +
> +	clk_en_a = mci_readl(host, CLKENA);
> +
> +	if (clk_en_a & clken_low_pwr) {
> +		mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
> +		mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
> +			     SDMMC_CMD_PRV_DAT_WAIT, 0);
> +	}
> +}
> +
>  static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  {
>  	struct dw_mci_slot *slot = mmc_priv(mmc);
> @@ -871,6 +898,14 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  	/* Enable/disable Slot Specific SDIO interrupt */
>  	int_mask = mci_readl(host, INTMASK);
>  	if (enb) {
> +		/*
> +		 * Turn off low power mode if it was enabled.  This is a bit of
> +		 * a heavy operation and we disable / enable IRQs a lot, so
> +		 * we'll leave low power mode disabled and it will get
> +		 * re-enabled again in dw_mci_setup_bus().
> +		 */
> +		dw_mci_disable_low_power(slot);
> +
>  		mci_writel(host, INTMASK,
>  			   (int_mask | SDMMC_INT_SDIO(slot->id)));
>  	} else {

Basically, disabling low power mode doesn't affect origin working.
This patch will guarantees to supply the clock while sdio interrupt is activated.
Looks good to me.
Chris, feel free to add my ack.

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

> --
> 1.7.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

