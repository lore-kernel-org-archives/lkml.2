Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2FZWHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:07:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55863 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2FZWHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:07:36 -0400
Date: Tue, 26 Jun 2012 15:07:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: ozwpan: Fix compilation issue due to
 export.h
Message-ID: <20120626220732.GA21906@kroah.com>
References: <1340712221-6750-1-git-send-email-rgujare@ozmodevices.com>
 <1340712221-6750-3-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340712221-6750-3-git-send-email-rgujare@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 01:03:40PM +0100, Rupesh Gujare wrote:
> Fixes compilation error caused due to header file.
> 
> Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
> ---
>  drivers/staging/ozwpan/ozhcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
> index 251f07c..e3efa41 100644
> --- a/drivers/staging/ozwpan/ozhcd.c
> +++ b/drivers/staging/ozwpan/ozhcd.c
> @@ -28,7 +28,7 @@
>  #include <linux/usb.h>
>  #include <linux/jiffies.h>
>  #include <linux/slab.h>
> -#include <linux/export.h>
> +#include <linux/module.h>

I don't understand, what is this fixing?  It builds for me ok here, why
is module.h needed instead of export.h?

confused,

greg k-h
