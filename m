Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2KTB6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:58:54 -0500
Received: from void.printf.net ([89.145.121.20]:47215 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2KTB6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:58:52 -0500
From: Chris Ball <cjb@laptop.org>
To: <wei_wang@realsil.com.cn>
Cc: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <oakad@yahoo.com>,
        <bp@alien8.de>
Subject: Re: [PATCH 1/2] mmc: Configure SD_CFG2 register in sd_rw_multi
References: <cover.1353373737.git.wei_wang@realsil.com.cn>
	<d26d1ae11c300cd96ed01a72cc099fe6d813d7c2.1353373737.git.wei_wang@realsil.com.cn>
Date: Mon, 19 Nov 2012 20:58:38 -0500
In-Reply-To: <d26d1ae11c300cd96ed01a72cc099fe6d813d7c2.1353373737.git.wei_wang@realsil.com.cn>
	(wei wang's message of "Tue, 20 Nov 2012 09:12:29 +0800")
Message-ID: <87txslf31t.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 19 2012, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
>
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index 0e934bf..067dd46 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -405,6 +405,7 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
>  	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DATA_SOURCE,
>  			0x01, RING_BUFFER);
>  
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF, cfg2);
>  	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
>  			trans_mode | SD_TRANSFER_START);
>  	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,

Please write commit messages -- if this fixes a bug, what's the nature
of the bug that it fixes?  Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
