Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1FYWxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:53:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18973 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1FYWxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:53:54 -0400
Date: Sun, 26 Jun 2011 00:44:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: =?ISO-8859-15?Q?Torbj=F6rn_Svensson?= 
	<azoff@svenskalinuxforeningen.se>
cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
        Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Corrected a small typo in help text for
 CONFIG_CLEANCACHE
In-Reply-To: <4E06633F.9010307@svenskalinuxforeningen.se>
Message-ID: <alpine.LNX.2.00.1106260043570.23991@swampdragon.chaosbits.net>
References: <4E06633F.9010307@svenskalinuxforeningen.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-525282525-1309041893=:23991"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-525282525-1309041893=:23991
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 26 Jun 2011, Torbjörn Svensson wrote:

> Corrected a small typo in the help text for CONFIG_CLEANCACHE.
> 
> Signed-of-by: Torbjörn Svensson <azoff@svenskalinuxforeningen.se>
> ---
>  mm/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8ca47a5..f2f1ca1 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -356,7 +356,7 @@ config CLEANCACHE
>  	  for clean pages that the kernel's pageframe replacement algorithm
>  	  (PFRA) would like to keep around, but can't since there isn't enough
>  	  memory.  So when the PFRA "evicts" a page, it first attempts to use
> -	  cleancacne code to put the data contained in that page into
> +	  cleancache code to put the data contained in that page into
>  	  "transcendent memory", memory that is not directly accessible or
>  	  addressable by the kernel and is of unknown and possibly
>  	  time-varying size.  And when a cleancache-enabled
> 
For what it's worth;

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-525282525-1309041893=:23991--
