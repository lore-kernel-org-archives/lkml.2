Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab0LHF02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:26:28 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50371 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0LHF01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:26:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wyGqT9tzn0CH0s30yJT/sQLJs9g7hVxayJa+Cde5pUSfYRmadsbWqjAWC+dTZUci+Y
         e57AgDC+1FBTVAp5HCxtoioqHQcWHbmhjlS3J9rrT8N7BCpyFEY9KIwA9/gW4+j8wtW/
         n9EohJyk7nSAl/j4NDoJLMsTCm0YH7S/wUUTs=
Subject: Re: [PATCH] hrtimer: fix a typo in comment
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <1291784991-5047-1-git-send-email-namhyung@gmail.com>
References: <1291784991-5047-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 14:18:47 +0900
Message-ID: <1291785527.1672.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops. I forgot CC-ing to trivial.


2010-12-08 (수), 14:09 +0900, Namhyung Kim:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  kernel/hrtimer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 72206cf..66163df 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1774,7 +1774,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
>  	}
>  
>  	/*
> -	 * A NULL parameter means "inifinte"
> +	 * A NULL parameter means "infinite"
>  	 */
>  	if (!expires) {
>  		schedule();


-- 
Regards,
Namhyung Kim


