Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2BPJ2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:28:05 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:50964 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2BPJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:28:00 -0500
Date: Thu, 16 Feb 2012 11:27:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Danny Kukawka <dkukawka@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adp1653: included linux/module.h twice
Message-ID: <20120216092755.GD7784@valkosipuli.localdomain>
References: <1329333644-32048-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329333644-32048-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Danny,

On Wed, Feb 15, 2012 at 08:20:44PM +0100, Danny Kukawka wrote:
> drivers/media/video/adp1653.c included 'linux/module.h' twice,
> remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/media/video/adp1653.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index 12eedf4..6e7d094 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -33,7 +33,6 @@
>  #include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/i2c.h>
> -#include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/version.h>
>  #include <media/adp1653.h>

Thanks for the patch. However, I've got a patch in my tree that already
contains this change.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
