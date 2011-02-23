Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab1BWJpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:45:06 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54955 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1BWJpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Yf4zgHHgO4S32psbsFRrX/ICmySgWysCXq//V8QZs7x38xnxPw9sV4Hn4wHV+PdDFC
         CWiEatJnO8nuUI6rw/16/tnx1t65x3WiiLOWIxiawcaQkspJFwEO4U53gPX4mYyZkJLo
         IQTcozrr/nR2aupH02dfp7GMqKHwz3oe3h+iY=
Date: Wed, 23 Feb 2011 17:44:53 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] MAINTAINERS: Add missing : after HR Timers F tag
Message-ID: <20110223094452.GC3090@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <cover.1298439175.git.joe@perches.com>
 <495c1ab9755c86d1dfb037db5ed444fcd2e7ac21.1298439175.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495c1ab9755c86d1dfb037db5ed444fcd2e7ac21.1298439175.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:41:57PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 920d8d3..fc5d548 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2973,7 +2973,7 @@ F:	kernel/hrtimer.c
>  F:	kernel/time/clockevents.c
>  F:	kernel/time/tick*.*
>  F:	kernel/time/timer_*.c
> -F	include/linux/clockevents.h
> +F:	include/linux/clockevents.h
>  F:	include/linux/hrtimer.h
>  
>  HIGH-SPEED SCC DRIVER FOR AX.25
> -- 
> 1.7.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
