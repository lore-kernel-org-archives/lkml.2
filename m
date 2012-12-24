Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2LXKLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 05:11:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab2LXKLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 05:11:36 -0500
Date: Mon, 24 Dec 2012 11:11:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
Subject: Re: [PATCH 2/7] MFD:rtsx: Remove redundant code
Message-ID: <20121224101134.GB6702@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
References: <cover.1356319097.git.wei_wang@realsil.com.cn>
 <19e2c741f89b80b9d1640ff00902b1cc3f76a171.1356319097.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19e2c741f89b80b9d1640ff00902b1cc3f76a171.1356319097.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 02:03:24PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rtsx_pcr.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index 3a44efa..fa2c2bc 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -325,7 +325,6 @@ static void rtsx_pci_add_sg_tbl(struct rtsx_pcr *pcr,
>  	val = ((u64)addr << 32) | ((u64)len << 12) | option;
>  
>  	put_unaligned_le64(val, ptr);
> -	ptr++;
>  	pcr->sgi++;

Hmm, one has to look at the whole function to understand that the ptr++
statement is actually useless. A sentence or two as a the commit message
wouldn't hurt, IMHO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
