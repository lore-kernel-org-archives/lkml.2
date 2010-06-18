Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0FRXhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 19:37:06 -0400
Received: from kroah.org ([198.145.64.141]:56214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab0FRXhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 19:37:05 -0400
Date: Fri, 18 Jun 2010 16:36:41 -0700
From: Greg KH <greg@kroah.com>
To: Matti Lammi <mattij.lammi@gmail.com>
Cc: gregkh@suse.de, horms@verge.net.au, dcb314@hotmail.com, sharms@ubuntu.com,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Drivers: Staging: Fixed several checkpatch.pl issues
Message-ID: <20100618233641.GA5435@kroah.com>
References: <1276764387-14791-1-git-send-email-mattij.lammi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276764387-14791-1-git-send-email-mattij.lammi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 11:46:27AM +0300, Matti Lammi wrote:
> Moved braces and removed some unnecessary spaces. Just small fixes.
> 
> Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
> ---
>  drivers/staging/otus/ioctl.c |   41 +++++++++++++++++------------------------
>  1 files changed, 17 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
> index a48c8e4..adf3f14 100644
> --- a/drivers/staging/otus/ioctl.c
> +++ b/drivers/staging/otus/ioctl.c
> @@ -63,0 +63,0 @@
> 

Something is really wrong here, this patch is saying it is corrupted,
yet I can't figure out why.

Care to resend all of the otus patches again after verifying that you
can apply them yourself?

thanks,

greg k-h
