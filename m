Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2K3LrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:47:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab2K3LrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:47:16 -0500
Date: Fri, 30 Nov 2012 06:47:10 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cifs: Remove unused cEVENT macro
Message-ID: <20121130064710.1bcd227b@tlielax.poochiereds.net>
In-Reply-To: <7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe@perches.com>
References: <cover.1354217746.git.joe@perches.com>
	<7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 11:37:18 -0800
Joe Perches <joe@perches.com> wrote:

> It uses an undefined KERN_EVENT and is itself unused.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/cifs/cifs_debug.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index c0c68bb..b0fc344 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -63,12 +63,6 @@ do {						\
>  /* debug event message: */
>  extern int cifsERROR;
>  
> -#define cEVENT(fmt, arg...)						\
> -do {									\
> -	if (cifsERROR)							\
> -		printk(KERN_EVENT "%s: " fmt "\n", __FILE__, ##arg);	\
> -} while (0)
> -
>  /* error event message: e.g., i/o error */
>  #define cifserror(fmt, arg...)					\
>  do {								\
> @@ -88,7 +82,6 @@ do {						\
>   */
>  #else		/* _CIFS_DEBUG */
>  #define cERROR(set, fmt, arg...)
> -#define cEVENT(fmt, arg...)
>  #define cFYI(set, fmt, arg...)
>  #define cifserror(fmt, arg...)
>  #endif		/* _CIFS_DEBUG */

Yay! More cruft removal!

Reviewed-by: Jeff Layton <jlayton@redhat.com>
