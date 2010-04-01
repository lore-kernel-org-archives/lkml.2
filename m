Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0DAMpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:45:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25307 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0DAMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:45:44 -0400
Subject: Re: [PATCH] [mtd, nand] Remove stray endchoice from help text
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <8763591d3w.fsf@tac.ki.iif.hu>
References: <8763591d3w.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 15:43:00 +0300
Message-ID: <1270125780.15073.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2010 12:45:17.0698 (UTC) FILETIME=[2EB02E20:01CAD199]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-06 at 20:09 +0100, Ferenc Wagner wrote:
> Signed-off-by: Ferenc Wagner <wferi@niif.hu>
> ---
>  drivers/mtd/nand/Kconfig |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 677cd53..d68bd6e 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -358,8 +358,6 @@ config MTD_NAND_ATMEL_ECC_NONE
>  
>  	  If unsure, say N
>  
> -	  endchoice
> -
>  endchoice
>  
>  config MTD_NAND_PXA3xx

Pushed to l2-mtd-2.6.git / master, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

