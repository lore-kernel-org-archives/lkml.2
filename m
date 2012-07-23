Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2GWHCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:02:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19894 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2GWHCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:02:07 -0400
Date: Mon, 23 Jul 2012 10:01:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, Lior Dotan <liodot@gmail.com>
Subject: Re: [PATCH 1/2] Staging: slicoss: Clean up tabs vs spaces in slic.h
Message-ID: <20120723070150.GA4352@mwanda>
References: <alpine.LNX.2.00.1207222253370.31033@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207222253370.31033@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 10:57:09PM +0200, Jesper Juhl wrote:
> Make it match CodingStyle a bit better, tab/space wise.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/staging/slicoss/slic.h | 751 ++++++++++++++++++++---------------------
>  1 file changed, 374 insertions(+), 377 deletions(-)
> 
> diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
> index ebdcc6f..0deb670 100644
> --- a/drivers/staging/slicoss/slic.h
> +++ b/drivers/staging/slicoss/slic.h
> @@ -42,61 +42,62 @@
>  #define __SLIC_DRIVER_H__
>  
>  /* firmware stuff */
> -#define OASIS_UCODE_VERS_STRING	"1.2"
> -#define OASIS_UCODE_VERS_DATE  	"2006/03/27 15:10:37"
> -#define OASIS_UCODE_HOSTIF_ID  	3
> +#define OASIS_UCODE_VERS_STRING "1.2"
> +#define OASIS_UCODE_VERS_DATE "2006/03/27 15:10:37"
> +#define OASIS_UCODE_HOSTIF_ID 3

No.  The original was far better.

Looking through the rest of the patch, some of these changes are ok,
and some are nonsense.

regards,
dan carpenter

