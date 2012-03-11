Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2CKKMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:12:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54541 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2CKKMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:12:02 -0400
Message-ID: <4F5C7A1D.60208@mvista.com>
Date: Sun, 11 Mar 2012 14:10:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH v2 2/2] ata: AT91 ata driver requires AT91_HAS_PATA
References: <1331415380-10928-1-git-send-email-alan@signal11.us> <1331415562-10994-1-git-send-email-alan@signal11.us>
In-Reply-To: <1331415562-10994-1-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-03-2012 1:39, Alan Ott wrote:

> This driver uses registers defined in a per-soc header file.
> Since not every soc in the at91 platform defines those, make
> the Kconfig option dependent on those which define
> AT91_HAS_PATA.

> This is based on a patch by Arnd Bergmann.

> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> Signed-off-by: Alan Ott<alan@signal11.us>
> CC: Ben Dooks<ben-linux@fluff.org>
> ---
>   drivers/ata/Kconfig |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)

> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 6bdedd7..fdb8c90 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -731,6 +731,7 @@ config PATA_AT32
>   config PATA_AT91
>   	tristate "PATA support for AT91SAM9260"
>   	depends on ARM && ARCH_AT91

    Is this line still needed?

> +	depends on AT91_HAS_PATA
>   	help
>   	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.

WBR, Sergei
