Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1GJWcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 18:32:17 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19906 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1GJWcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 18:32:14 -0400
Date: Mon, 11 Jul 2011 00:32:13 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Edwin van Vliet <edwin@cheatah.nl>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/tty/synclink: remove double comment
In-Reply-To: <1310336077-26835-1-git-send-email-edwin@cheatah.nl>
Message-ID: <alpine.LNX.2.00.1107110032000.2818@swampdragon.chaosbits.net>
References: <1310336077-26835-1-git-send-email-edwin@cheatah.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Edwin van Vliet wrote:

> Redundant comment line was removed
> 
> Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
> ---
>  drivers/tty/synclink.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
> index 272e417..e67fb20 100644
> --- a/drivers/tty/synclink.c
> +++ b/drivers/tty/synclink.c
> @@ -2124,7 +2124,6 @@ static int mgsl_write(struct tty_struct * tty,
>  	if ( info->params.mode == MGSL_MODE_HDLC ||
>  			info->params.mode == MGSL_MODE_RAW ) {
>  		/* operating in synchronous (frame oriented) mode */
> -		/* operating in synchronous (frame oriented) mode */
>  		if (info->tx_active) {
>  
>  			if ( info->params.mode == MGSL_MODE_HDLC ) {
Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

