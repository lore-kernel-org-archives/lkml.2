Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1BNXOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:14:02 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12608 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1BNXOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:14:00 -0500
Date: Tue, 15 Feb 2011 00:12:57 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] hvcs: fix typo in comment
In-Reply-To: <1297724735.1793.34.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102150012390.4530@swampdragon.chaosbits.net>
References: <1297724735.1793.34.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/char/hvcs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
> index bedc6c1..af4e650 100644
> --- a/drivers/tty/hvc/hvcs.c
> +++ b/drivers/tty/hvc/hvcs.c
> @@ -292,7 +292,7 @@ struct hvcs_struct {
>  	/*
>  	 * Any variable below the kref is valid before a tty is connected and
>  	 * stays valid after the tty is disconnected.  These shouldn't be
> -	 * whacked until the koject refcount reaches zero though some entries
> +	 * whacked until the kobject refcount reaches zero though some entries
>  	 * may be changed via sysfs initiatives.
>  	 */
>  	struct kref kref; /* ref count & hvcs_struct lifetime */
> 

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

