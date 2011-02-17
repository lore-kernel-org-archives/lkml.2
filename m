Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab1BQPo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:44:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab1BQPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:44:56 -0500
Date: Thu, 17 Feb 2011 16:44:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arvind R <arvino55@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37 1/4] edac: correct commented info, i82975x
In-Reply-To: <AANLkTimiwirjc2Ow_J6TgmVFXRC=i7-gb4cY-hYMCSgx@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1102171644460.2160@pobox.suse.cz>
References: <AANLkTimiwirjc2Ow_J6TgmVFXRC=i7-gb4cY-hYMCSgx@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Arvind R wrote:

> Subject: [PATCH 2.6.37 1/4] edac: correct commented info
> 
> wrong comments in i82975x driver corrected
> 
> Signed-off-by: Arvind R. <arvino55@gmail.com>
> ---
>  i82975x_edac.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> ---
> diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
> --- a/drivers/edac/i82975x_edac.c
> +++ b/drivers/edac/i82975x_edac.c
> @@ -160,8 +160,8 @@ NOTE: Only ONE of the three must be enab
>  					 * 3:2  Rank 1 architecture
>  					 * 1:0  Rank 0 architecture
>  					 *
> -					 * 00 => x16 devices; i.e 4 banks
> -					 * 01 => x8  devices; i.e 8 banks
> +					 * 00 => 4 banks
> +					 * 01 => 8 banks
>  					 */
>  #define I82975X_C0BNKARC	0x10e
>  #define I82975X_C1BNKARC	0x18e
> @@ -344,11 +344,7 @@ static int dual_channel_active(void __io
>  static enum dev_type i82975x_dram_type(void __iomem *mch_window, int rank)
>  {
>  	/*
> -	 * ASUS P5W DH either does not program this register or programs
> -	 * it wrong!
> -	 * ECC is possible on i92975x ONLY with DEV_X8 which should mean 'val'
> -	 * for each rank should be 01b - the LSB of the word should be 0x55;
> -	 * but it reads 0!
> +	 * ECC is possible on i92975x ONLY with DEV_X8
>  	 */
>  	return DEV_X8;
>  }

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
