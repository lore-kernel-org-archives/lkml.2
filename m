Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2HNCAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:00:30 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45096 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754458Ab2HNCA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:00:29 -0400
X-Sasl-enc: /QaXXuRcV7pQk1qErAQez79+r/da3app7URMlzckG3jW 1344909628
Date: Mon, 13 Aug 2012 19:00:27 -0700
From: Greg KH <greg@kroah.com>
To: Cruz Julian Bishop <cruzjbishop@gmail.com>
Cc: swetland@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Redocument some functions in android/logger.c
Message-ID: <20120814020027.GA26758@kroah.com>
References: <1343796860-7025-1-git-send-email-cruzjbishop@gmail.com>
 <1343796860-7025-5-git-send-email-cruzjbishop@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343796860-7025-5-git-send-email-cruzjbishop@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:54:19PM +1000, Cruz Julian Bishop wrote:
> I will document the rest later if they remain unchanged
> Normally, I would do them all at once, but I don't have the chance to do them all at the moment
> 
> Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
> ---
>  drivers/staging/android/logger.c |   90 +++++++++++++++++++++++++-------------
>  1 file changed, 60 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 1d5ed47..226d8b5 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -78,15 +78,20 @@ struct logger_reader {
>  	size_t			r_off;
>  };
>  
> -/* logger_offset - returns index 'n' into the log via (optimized) modulus */
> +/**
> + * logger_offset() - returns index 'n' into the log via (optimized) modulus
> + * @log:	The log being referenced
> + * @n:		The index number being referenced
> + */
>  static size_t logger_offset(struct logger_log *log, size_t n)

There is no need to document static functions in this style, unless you
really feel it is needed.

For simple things like this, it isn't needed at all, so I'm not going to
apply this patch, sorry.

greg k-h
