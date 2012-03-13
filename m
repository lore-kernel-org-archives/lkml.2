Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2CMUqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:46:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43758 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2CMUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:46:23 -0400
Message-ID: <4F5FB21C.6070607@pobox.com>
Date: Tue, 13 Mar 2012 16:46:20 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH v2 2/2] ata: AT91 ata driver requires AT91_HAS_PATA
References: <1331415380-10928-1-git-send-email-alan@signal11.us> <1331415562-10994-1-git-send-email-alan@signal11.us>
In-Reply-To: <1331415562-10994-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 04:39 PM, Alan Ott wrote:
> This driver uses registers defined in a per-soc header file.
> Since not every soc in the at91 platform defines those, make
> the Kconfig option dependent on those which define
> AT91_HAS_PATA.
>
> This is based on a patch by Arnd Bergmann.
>
> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> Signed-off-by: Alan Ott<alan@signal11.us>
> CC: Ben Dooks<ben-linux@fluff.org>
> ---
>   drivers/ata/Kconfig |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 6bdedd7..fdb8c90 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -731,6 +731,7 @@ config PATA_AT32
>   config PATA_AT91
>   	tristate "PATA support for AT91SAM9260"
>   	depends on ARM&&  ARCH_AT91
> +	depends on AT91_HAS_PATA
>   	help

Acked-by: Jeff Garzik <jgarzik@redhat.com>



