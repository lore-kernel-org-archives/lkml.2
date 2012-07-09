Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2GITJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:09:39 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:24354 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2GITJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:09:38 -0400
Date: Mon, 9 Jul 2012 21:09:35 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: dl9pf@gmx.de
cc: =?ISO-8859-15?Q?Jan-Simon_M=F6ller?= <jansimon.moeller@gmx.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trivial: Fix typo in include/linux/clk.h .
In-Reply-To: <1341860778-23898-1-git-send-email-dl9pf@gmx.de>
Message-ID: <alpine.LNX.2.00.1207092108370.6295@swampdragon.chaosbits.net>
References: <1341860778-23898-1-git-send-email-dl9pf@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-746669498-1341860976=:6295"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-746669498-1341860976=:6295
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 9 Jul 2012, dl9pf@gmx.de wrote:

> From: Jan-Simon Möller <jansimon.moeller@gmx.de>
> 
> Signed-off-by: Jan-Simon Möller <jansimon.moeller@gmx.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/clk.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index f7bd858..116172f 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -123,7 +123,7 @@ static inline void clk_unprepare(struct clk *clk)
>  /**
>   * clk_get - lookup and obtain a reference to a clock producer.
>   * @dev: device for clock "consumer"
> - * @id: clock comsumer ID
> + * @id: clock consumer ID
>   *
>   * Returns a struct clk corresponding to the clock producer, or
>   * valid IS_ERR() condition containing errno.  The implementation
> @@ -140,7 +140,7 @@ struct clk *clk_get(struct device *dev, const char *id);
>  /**
>   * devm_clk_get - lookup and obtain a managed reference to a clock producer.
>   * @dev: device for clock "consumer"
> - * @id: clock comsumer ID
> + * @id: clock consumer ID
>   *
>   * Returns a struct clk corresponding to the clock producer, or
>   * valid IS_ERR() condition containing errno.  The implementation
> 
Looks correct to me :-)

Acked-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-746669498-1341860976=:6295--
