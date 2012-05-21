Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2EUObj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:31:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28951 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab2EUObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:31:38 -0400
Date: Mon, 21 May 2012 17:35:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NEXT]staging: "rts_pstor" Fix typos.
Message-ID: <20120521143530.GC4637@mwanda>
References: <1337609955-15544-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337609955-15544-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 07:19:15AM -0700, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
  ^
Your scripts are adding an extra space here.

> 
> ---
> 
> The below patch fixes some typos found while reading through rts_pstor.

This could go in the patch description if you wanted.

> 
>  drivers/staging/rts_pstor/ms.c |    2 +-
>  drivers/staging/rts_pstor/sd.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
> index 0bf6d95..3b75739 100644
> --- a/drivers/staging/rts_pstor/ms.c
> +++ b/drivers/staging/rts_pstor/ms.c
> @@ -2488,7 +2488,7 @@ int reset_ms_card(struct rtsx_chip *chip)
>  
>  	if (!CHK_MSPRO(ms_card)) {
>  		/* Build table for the last segment,
> -		 * to check if L2P talbe block exist,erasing it
> +		 * to check if L2P table block exist,erasing it

I still have no idea what this comment means but "exist" => "exists"
and it needs a space after the comma.

>  		 */
>  		retval = ms_build_l2p_tbl(chip, ms_card->total_block / 512 - 1);
>  		if (retval != STATUS_SUCCESS) {

regards,
dan carpenter
