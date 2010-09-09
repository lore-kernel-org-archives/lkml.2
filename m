Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0IIJ3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:29:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34833 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0IIJ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ELmk3d3/MuboWRnHZU8gNTshuuNsHdXQThYfk0aGGsXKc6FOpk6xtQskhX9bj7Gq4y
         eO2+yX7n8XA+Fy73HMs+6YgcAVyRzvkThwmRlVdT5V0WxVw7CJRVrvosq2Z8znW8tj1c
         lmP8t0VoM2sYMpCGgyllYrstW8MtsCCGYjbTM=
Date: Thu, 9 Sep 2010 11:29:35 +0200
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: Nikitas Angelinas <nikitasangelinas@gmail.com>
Cc: gregkh@suse.de, more.andres@gmail.com, lieb@canonical.com,
        forest@alittletooquiet.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers/staging/vt6656: use ARRAY_SIZE macro in
 channel.c
Message-ID: <20100909092915.GA4994@air>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
 <1283981275-5098-1-git-send-email-nikitasangelinas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283981275-5098-1-git-send-email-nikitasangelinas@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this definition is not used anywhere in the driver and thus can
be removed.

On Wed, Sep 08, 2010 at 10:27:55PM +0100, Nikitas Angelinas wrote:
> Replace (sizeof(ChannelRuleTab) / sizeof(ChannelRuleTab[0])) with
> ARRAY_SIZE(ChannelRuleTab) in drivers/staging/vt6656/channel.c
> 
> Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
> ---
>  drivers/staging/vt6656/channel.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
> index 6ad03e4..a2460ae 100644
> --- a/drivers/staging/vt6656/channel.c
> +++ b/drivers/staging/vt6656/channel.c
> @@ -34,6 +34,7 @@
>   *
>   */
>  
> +#include <linux/kernel.h>
>  #include "country.h"
>  #include "channel.h"
>  #include "rf.h"
> @@ -367,7 +368,7 @@ static  struct
>  /*                                           1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  */
>  };
>  
> -#define NUM_RULES	(sizeof(ChannelRuleTab) / sizeof(ChannelRuleTab[0]))
> +#define NUM_RULES	ARRAY_SIZE(ChannelRuleTab)
>  
>  /*---------------------  Export function  -------------------------*/
>  /************************************************************************
> -- 
> 1.7.2.3
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

-- 
Charles Clément
