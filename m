Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2JLEtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 00:49:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52966 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2JLEtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 00:49:12 -0400
Message-ID: <5077A13F.3090100@gmail.com>
Date: Fri, 12 Oct 2012 13:49:03 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: lm3639: Return proper error in lm3639_bled_mode_store
 error paths
References: <1349932292.8495.2.camel@phoenix>
In-Reply-To: <1349932292.8495.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012년 10월 11일 14:11, Axel Lin 쓴 글:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/video/backlight/lm3639_bl.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
> index c6915c6..585949b 100644
> --- a/drivers/video/backlight/lm3639_bl.c
> +++ b/drivers/video/backlight/lm3639_bl.c
> @@ -206,11 +206,11 @@ static ssize_t lm3639_bled_mode_store(struct device *dev,
>   
>   out:
>   	dev_err(pchip->dev, "%s:i2c access fail to register\n", __func__);
> -	return size;
> +	return ret;
>   
>   out_input:
>   	dev_err(pchip->dev, "%s:input conversion fail\n", __func__);
> -	return size;
> +	return ret;
>   
>   }
>   

Thank you Alex for fixing code.
Acked-by: G.Shark Jeong<gshark.jeong@gmail.com>
