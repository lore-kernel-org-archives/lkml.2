Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544Ab0KQJHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:07:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40794 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab0KQJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:07:04 -0500
Date: Wed, 17 Nov 2010 10:06:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: Re: [RESEND PATCH] tags: put function prototypes back!
Message-ID: <20101117090654.GZ8942@pengutronix.de>
References: <4C176968.8070807@suse.cz> <1288862656-26707-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288862656-26707-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marek,

On Thu, Nov 04, 2010 at 10:24:16AM +0100, Uwe Kleine-König wrote:
> Commit 7db86dc (ctags: usability fix) removed function prototypes from
> tags file claiming "It makes no real sense to include function
> prototypes".
> But it is useful for quickly determining which header file developer
> needs to include to fix compilation.
> 
> Now if someone wants to remove forward declatations (which I agree are
> baggage), write a postprocessing script.
While sorting my pending patches I noticed that there's a typo, can you
please do s/declatations/declarations/ when taking the patch.
(Or tell me to resend an updated patch.)  (I'd say the sentence before
needs an "a" before developer, I'm not a native speaker though, so I
kept Alexey's wording.)

Best regards and thanks
Uwe 

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  scripts/tags.sh |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 8509bb5..e091db3 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -123,7 +123,7 @@ exuberant()
>  	-I ____cacheline_internodealigned_in_smp                \
>  	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
>  	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
> -	--extra=+f --c-kinds=-px                                \
> +	--extra=+f --c-kinds=+px                                \
>  	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
>  	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
>  
> -- 
> 1.7.2.3
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
