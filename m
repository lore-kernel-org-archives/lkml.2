Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1EQI0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:26:40 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13476 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1EQI0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:26:37 -0400
Date: Tue, 17 May 2011 10:19:20 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: =?ISO-8859-15?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>
cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH trivial] timers-howto: fix a typo ("unsgined")
In-Reply-To: <1305573335-28361-1-git-send-email-j.neuschaefer@gmx.net>
Message-ID: <alpine.LNX.2.00.1105171018270.15079@swampdragon.chaosbits.net>
References: <1305573335-28361-1-git-send-email-j.neuschaefer@gmx.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-179759578-1305620360=:15079"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-179759578-1305620360=:15079
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 16 May 2011, Jonathan Neuschäfer wrote:

> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  Documentation/timers/timers-howto.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/timers/timers-howto.txt b/Documentation/timers/timers-howto.txt
> index c9ef29d..038f8c7 100644
> --- a/Documentation/timers/timers-howto.txt
> +++ b/Documentation/timers/timers-howto.txt
> @@ -24,7 +24,7 @@ ATOMIC CONTEXT:
>  
>  	ndelay(unsigned long nsecs)
>  	udelay(unsigned long usecs)
> -	mdelay(unsgined long msecs)
> +	mdelay(unsigned long msecs)
>  
>  	udelay is the generally preferred API; ndelay-level
>  	precision may not actually exist on many non-PC devices.

Looks good to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-179759578-1305620360=:15079--
