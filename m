Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0FYN3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:29:49 -0400
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59642 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab0FYN3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:29:48 -0400
Message-ID: <4C24AF41.3080101@bu3sch.de>
Date: Fri, 25 Jun 2010 15:29:37 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] b43: Add SDIO_DEVICE() for EW-CG1102GC
References: <20100625093254.9484.69877.sendpatchset@t400s> (sfid-20100625_113248_442184_13EC6E79)
In-Reply-To: <20100625093254.9484.69877.sendpatchset@t400s> (sfid-20100625_113248_442184_13EC6E79)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 11:32 AM, Magnus Damm wrote:
> From: Magnus Damm<damm@opensource.se>
>
> This patch enables the EW-CG1102GC SDIO card in the b43 driver.
>
> b43-sdio mmc0:0001:1: Chip ID 14e4:4318
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x0D, vendor 0x4243)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x09, vendor 0x4243)
> ssb: Core 2 found: PCI (cc 0x804, rev 0x0C, vendor 0x4243)
> ssb: Core 3 found: PCMCIA (cc 0x80D, rev 0x07, vendor 0x4243)
> b43-phy0: Broadcom 4318 WLAN found (core revision 9)
> b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
> b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
>
> Tested with openfwwf-5.2 using a SuperH SDHI host controller.
>
> Signed-off-by: Magnus Damm<damm@opensource.se>
> ---
>
>   drivers/net/wireless/b43/sdio.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- 0001/drivers/net/wireless/b43/sdio.c
> +++ work/drivers/net/wireless/b43/sdio.c	2010-06-25 18:20:46.000000000 +0900
> @@ -182,6 +182,7 @@ static void b43_sdio_remove(struct sdio_
>
>   static const struct sdio_device_id b43_sdio_ids[] = {
>   	{ SDIO_DEVICE(0x02d0, 0x044b) }, /* Nintendo Wii WLAN daughter card */
> +	{ SDIO_DEVICE(0x0092, 0x0004) }, /* C-guys, Inc. EW-CG1102GC */
>   	{ },
>   };
>
>

ack

-- 
Greetings Michael.
