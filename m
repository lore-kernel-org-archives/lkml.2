Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2GQCLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:11:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52635 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2GQCLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:11:10 -0400
Date: Mon, 16 Jul 2012 19:11:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, khc@pm.waw.pl
Subject: Re: [PATCH v2] staging: sbe-2t3e3: Remove code that will never
 execute
Message-ID: <20120717021106.GA698@kroah.com>
References: <1342146469-26206-1-git-send-email-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342146469-26206-1-git-send-email-marcos.souza.org@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 11:27:49PM -0300, Marcos Paulo de Souza wrote:
> This patch removes all references of "if 0" blocks in the sbe-2t3e3 driver.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> ---
>  drivers/staging/sbe-2t3e3/2t3e3.h    |    3 --
>  drivers/staging/sbe-2t3e3/cpld.c     |   15 ---------
>  drivers/staging/sbe-2t3e3/ctrl.c     |   19 +++--------
>  drivers/staging/sbe-2t3e3/dc.c       |   17 ----------
>  drivers/staging/sbe-2t3e3/exar7250.c |   40 +++--------------------
>  drivers/staging/sbe-2t3e3/exar7300.c |   17 ----------
>  drivers/staging/sbe-2t3e3/intr.c     |   60 ++--------------------------------
>  drivers/staging/sbe-2t3e3/io.c       |   21 ------------
>  8 files changed, 10 insertions(+), 182 deletions(-)
> 
> diff --git a/drivers/staging/sbe-2t3e3/2t3e3.h b/drivers/staging/sbe-2t3e3/2t3e3.h
> index fe9f086..383f2cf 100644
> --- a/drivers/staging/sbe-2t3e3/2t3e3.h
> +++ b/drivers/staging/sbe-2t3e3/2t3e3.h
> 
> Just fix the commit message fo sbr-2t3e3 to sbe-2t3e3.
> 
> @@ -801,9 +801,6 @@ u32 cpld_read(struct channel *sc, u32 reg);

Woah, what is that line in the middle of the patch here?  That causes
git to (rightfully) choke on the patch.

Please fix this and resend.

thanks,

greg k-h
