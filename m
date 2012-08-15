Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2HOHHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 03:07:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50342 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2HOHHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 03:07:04 -0400
Date: Wed, 15 Aug 2012 10:06:55 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: kill MTD_NAND_VERIFY_WRITE
Message-ID: <20120815100655.479e2c39@pixies.home.jungo.com>
In-Reply-To: <1344998325-3279-1-git-send-email-shijie8@gmail.com>
References: <1344998325-3279-1-git-send-email-shijie8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Tue, 14 Aug 2012 22:38:45 -0400 Huang Shijie <shijie8@gmail.com> wrote:
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 588e989..0ca7257 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -22,15 +22,6 @@ menuconfig MTD_NAND
>  
>  if MTD_NAND
>  
> -config MTD_NAND_VERIFY_WRITE
> -	bool "Verify NAND page writes"
> -	help
> -	  This adds an extra check when data is written to the flash. The
> -	  NAND flash device internally checks only bits transitioning
> -	  from 1 to 0. There is a rare possibility that even though the
> -	  device thinks the write was successful, a bit could have been
> -	  flipped accidentally due to device wear or something else.
> -

There are some defconfig files which set CONFIG_MTD_NAND_VERIFY_WRITE.

I guess you should submit an accompanying patch that removes
CONFIG_MTD_NAND_VERIFY_WRITE from all defconfig files.

(also, trimmed the CC list for this specific discussion, seems unrelated
to all of the parties)

Regards,
Shmulik
