Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1LQWgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:36:55 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22765 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1LQWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:36:53 -0500
Date: Sat, 17 Dec 2011 23:36:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, trivial@kernel.org
Subject: Re: [PATCH][TRIVIAL] SCSI, pmcraid: Fix 'failed' misspelled as
 'faile' in error message
In-Reply-To: <alpine.LNX.2.00.1112172329580.21713@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1112172335460.21784@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1112172329580.21713@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Dec 2011, Jesper Juhl wrote:

> 

Please ignore this. I thought it had gotten lost, but I just found out 
that it's in linux-next via Jiri Kosina's tree.
Sorry about the noise.


> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/scsi/pmcraid.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 5163edb..ea8a0b4 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4105,7 +4105,7 @@ static long pmcraid_chr_ioctl(
>  	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
>  
>  	if (!hdr) {
> -		pmcraid_err("faile to allocate memory for ioctl header\n");
> +		pmcraid_err("failed to allocate memory for ioctl header\n");
>  		return -ENOMEM;
>  	}
>  
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

