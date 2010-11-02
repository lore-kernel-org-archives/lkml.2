Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0KBCan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 22:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0KBCal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 22:30:41 -0400
Subject: Re: [PATCH] libertas - remove duplicate header inclusions from cfg
From: Dan Williams <dcbw@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
        Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <alpine.LNX.2.00.1010301501430.7979@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301501430.7979@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 21:29:12 -0500
Message-ID: <1288664952.4003.33.camel@dcbw.foobar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 15:07 +0200, Jesper Juhl wrote:
> Hi,
> 
> drivers/net/wireless/libertas/cfg.c manages to include both 
> 'linux/wait.h' and 'linux/sched.h' twice. Once is enough for both headers.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  cfg.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 5046a00..73b2bee 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -9,8 +9,6 @@
>  #include <linux/sched.h>
>  #include <linux/wait.h>
>  #include <linux/slab.h>
> -#include <linux/sched.h>
> -#include <linux/wait.h>
>  #include <linux/ieee80211.h>
>  #include <net/cfg80211.h>
>  #include <asm/unaligned.h>
> 
> 


