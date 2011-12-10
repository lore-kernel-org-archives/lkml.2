Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab1LJNzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 08:55:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1LJNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 08:54:59 -0500
Date: Sat, 10 Dec 2011 14:54:56 +0100
From: Michal Marek <mmarek@suse.cz>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Finch <dot@dotat.at>
Subject: Re: [PATCH] unifdef: drop unused errno.h include
Message-ID: <20111210135456.GB22866@sepie.suse.cz>
References: <1323210410-27111-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323210410-27111-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 05:26:50PM -0500, Mike Frysinger wrote:
> This is the only header on my system that ends up requiring kernel
> headers, so if the kernel headers aren't available, we end up being
> unable to install kernel headers :).
> 
> Since this file doesn't actually use anything from errno.h, drop
> the include so it at least makes us a bit more robust on glibc.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  scripts/unifdef.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/unifdef.c b/scripts/unifdef.c
> index 7493c0e..c5dfae5 100644
> --- a/scripts/unifdef.c
> +++ b/scripts/unifdef.c
> @@ -48,7 +48,6 @@
>  
>  #include <ctype.h>
>  #include <err.h>
> -#include <errno.h>
>  #include <stdarg.h>
>  #include <stdbool.h>
>  #include <stdio.h>

Adding unifdef upstream maintainer to Cc. I can apply the patch to the
kernel copy if there is no objection from Tony.

Michal
