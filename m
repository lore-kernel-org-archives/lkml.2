Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0DVW3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:29:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:34631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab0DVW3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:29:36 -0400
Date: Thu, 22 Apr 2010 15:07:26 -0700
From: Greg KH <gregkh@suse.de>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: "Bartlomiej Zolnierkiewicz devel@driverdev.osuosl.org" 
	<bzolnier@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fix coding style errors of
 r8180_rtl8225z2.c
Message-ID: <20100422220726.GA23095@suse.de>
References: <4BD0C19F.3030809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD0C19F.3030809@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 11:37:35PM +0200, Roel Van Nyen wrote:
> Fix coding style errors
> 
> Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
> 
> ---
> 
>  drivers/staging/rtl8187se/r8180_rtl8225z2.c |   58 ++++++++++++++-------------
> 
>  1 files changed, 30 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
> 
> index 6edf5a4..9c38b3a 100644
> 
> --- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
> 
> +++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c

Very wierd, your email client doubled all of the lines.

Did you use git send-email to send this patch, or did you cut-and-paste
into gmail?  If the latter, please don't :)

thanks,

greg k-h
