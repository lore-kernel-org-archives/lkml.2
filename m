Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1C3A4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:56:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46775 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1C3A4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UNkYH19T7W/tSfW2MB/KLD+w67cq7olEqR9SO86862j/kcQHYKuj6LGOfUaZOq+Qux
         9YTwUVQa+n1L7UdpD8DTPsQhJPgcXdSwSUuJkO456dRe6g0FkS3HFa2uF0xVMOVWB2gH
         Ow7Ow7zKCrHjSSZzQZvo/yzHKnDr+jhJ0E2CA=
MIME-Version: 1.0
In-Reply-To: <201103300049.p2U0nxZf068304@www262.sakura.ne.jp>
References: <201103300049.p2U0nxZf068304@www262.sakura.ne.jp>
Date: Wed, 30 Mar 2011 09:56:34 +0900
Message-ID: <BANLkTiky_eupD2BXmvOEjGVES6buT08Dog@mail.gmail.com>
Subject: Re: [PATCH 2.6.39-rc1] Remove duplicated inline keyword in include/linux/memcontrol.h
From: Minchan Kim <minchan.kim@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is fixed by Eric Dumazet and on mmotm now.
Thanks for the report, Tetsuo. :)

2011/3/30 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> In file included from include/linux/swap.h:8,
>                 from include/linux/suspend.h:4,
>                 from arch/x86/kernel/asm-offsets.c:12:
> include/linux/memcontrol.h:220: error: duplicate `inline'
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/memcontrol.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.39-rc1.orig/include/linux/memcontrol.h
> +++ linux-2.6.39-rc1/include/linux/memcontrol.h
> @@ -216,7 +216,7 @@ static inline void mem_cgroup_del_lru_li
>        return ;
>  }
>
> -static inline inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
> +static inline void mem_cgroup_rotate_reclaimable_page(struct page *page)
>  {
>        return ;
>  }
>



-- 
Kind regards,
Minchan Kim
