Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1HHMAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:00:41 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1349 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab1HHMAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:00:40 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4E3FCFDC.1050000@broadcom.com>
Date: Mon, 8 Aug 2011 14:00:28 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
Organization: Broadcom
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Thomas Meyer" <thomas@m3y3r.de>
cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: use kzalloc()
References: <1312629992.5589.130.camel@localhost.localdomain>
In-Reply-To: <1312629992.5589.130.camel@localhost.localdomain>
X-WSS-ID: 62210E9B3KO3756450-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Thomas Meyer<thomas@m3y3r.de>

Acked-by: Roland Vossen <rvossen@broadcom.com>

> ---
>
> diff -u -p a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> --- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c 2011-07-28 15:32:17.863253745 +0200
> +++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c 2011-08-01 20:25:55.608031978 +0200
> @@ -6326,14 +6326,12 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bu
>   	BRCMF_TRACE(("%s: Enter\n", __func__));
>
>   	/* alloc chip_info_t */
> -	ci = kmalloc(sizeof(struct chip_info), GFP_ATOMIC);
> +	ci = kzalloc(sizeof(struct chip_info), GFP_ATOMIC);
>   	if (NULL == ci) {
>   		BRCMF_ERROR(("%s: malloc failed!\n", __func__));
>   		return -ENOMEM;
>   	}
>
> -	memset((unsigned char *)ci, 0, sizeof(struct chip_info));
> -
>   	/* bus/core/clk setup for register access */
>   	/* Try forcing SDIO core to do ALPAvail request only */
>   	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
>
>
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>


