Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2LUUnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:43:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2LUUne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:43:34 -0500
Date: Fri, 21 Dec 2012 18:43:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/media: Fix trailing statements should be on
 next line in go7007/go7007-fw.c
Message-ID: <20121221184311.2da34111@redhat.com>
In-Reply-To: <1352115573-8321-1-git-send-email-yamanetoshi@gmail.com>
References: <1352115526-8287-1-git-send-email-yamanetoshi@gmail.com>
	<1352115573-8321-1-git-send-email-yamanetoshi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon,  5 Nov 2012 20:39:33 +0900
YAMANE Toshiaki <yamanetoshi@gmail.com> escreveu:

> fixed below checkpatch error.
> - ERROR: trailing statements should be on next line
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/media/go7007/go7007-fw.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
> index f99c05b..cfce760 100644
> --- a/drivers/staging/media/go7007/go7007-fw.c
> +++ b/drivers/staging/media/go7007/go7007-fw.c
> @@ -725,7 +725,8 @@ static int vti_bitlen(struct go7007 *go)
>  {
>  	unsigned int i, max_time_incr = go->sensor_framerate / go->fps_scale;
>  
> -	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i);
> +	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i)
> +		;

Nah, this doesn't sound right to me. IMO, in this specific case,
checkpatch.pl did a bad job.

At least on my eyes, the first line is easier to read than the other
two ones.

>  	return i + 1;
>  }
>  


Regards,
Mauro
