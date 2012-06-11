Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2FKGsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:48:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37313 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2FKGsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:48:00 -0400
Message-ID: <4FD59480.8040004@kernel.dk>
Date: Mon, 11 Jun 2012 08:47:28 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, trivial@kernel.org
Subject: Re: [PATCH] mtip32xx: Remove unneeded version.h include in header
References: <alpine.LNX.2.00.1206100257130.15651@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1206100257130.15651@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 02:58 AM, Jesper Juhl wrote:
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/block/mtip32xx/mtip32xx.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
> index b2c88da..adb1aae 100644
> --- a/drivers/block/mtip32xx/mtip32xx.h
> +++ b/drivers/block/mtip32xx/mtip32xx.h
> @@ -26,7 +26,6 @@
>  #include <linux/ata.h>
>  #include <linux/interrupt.h>
>  #include <linux/genhd.h>
> -#include <linux/version.h>
>  
>  /* Offset of Subsystem Device ID in pci confoguration space */
>  #define PCI_SUBSYSTEM_DEVICEID	0x2E

An identical patch is already queed up in my for-linus branch (and is in
for-next):

http://git.kernel.dk/?p=linux-block.git;a=commit;h=87c9ea76a242c2f9063e2a8f3e90846c932c61a7

-- 
Jens Axboe

