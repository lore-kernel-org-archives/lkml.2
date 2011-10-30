Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab1J3R5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:57:11 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:40705 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934293Ab1J3R5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:57:09 -0400
Message-ID: <4EAD8FF2.8090002@xenotime.net>
Date: Sun, 30 Oct 2011 10:57:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/abx500: fix missing abx500 header file updates
References: <1319804135-2740-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1319804135-2740-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/11 05:15, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> I missed to include a patch adding the new silicon revision define
> CUT3P3 and remove the retired CUT0 versions of AB8500. Also delete
> the reference to the retired AB3550 from the header.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  include/linux/mfd/abx500.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
> index 896b5e4..e953b63 100644
> --- a/include/linux/mfd/abx500.h
> +++ b/include/linux/mfd/abx500.h
> @@ -6,7 +6,7 @@
>   *
>   * ABX500 core access functions.
>   * The abx500 interface is used for the Analog Baseband chip
> - * ab3100, ab3550, ab5500, and ab8500.
> + * AB3100, AB5500, and AB8500.
>   *
>   * Author: Mattias Wallin <mattias.wallin@stericsson.com>
>   * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
> @@ -35,11 +35,11 @@
>  #define AB5500_2_1	0x22
>  
>  /* AB8500 CIDs*/
> -#define AB8500_CUTEARLY	0x00
>  #define AB8500_CUT1P0	0x10
>  #define AB8500_CUT1P1	0x11
>  #define AB8500_CUT2P0	0x20
>  #define AB8500_CUT3P0	0x30
> +#define AB8500_CUT3P3	0x33
>  
>  /*
>   * AB3100, EVENTA1, A2 and A3 event register flags


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
