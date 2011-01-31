Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1AaOo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:44:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:55193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab1AaOoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:44:25 -0500
Date: Mon, 31 Jan 2011 15:44:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hidraw: Replace Confusing += Operator with =
In-Reply-To: <1296098718-6964-1-git-send-email-alan@signal11.us>
Message-ID: <alpine.LNX.2.00.1101311544120.5725@pobox.suse.cz>
References: <1296098718-6964-1-git-send-email-alan@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Alan Ott wrote:

> Setting of the return value of hidraw_read() uses the += operator when
> = is more appropriate.  There is no case where ret can be anything
> other than zero when the assignment is made, making = equivalent to
> += and much more clear.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  drivers/hid/hidraw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index 468e87b..66fbcba 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -91,7 +91,7 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
>  			ret = -EFAULT;
>  			goto out;
>  		}
> -		ret += len;
> +		ret = len;
>  

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
