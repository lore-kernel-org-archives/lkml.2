Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1DKT3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:29:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:47117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab1DKT3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:29:50 -0400
Date: Mon, 11 Apr 2011 12:27:33 -0700
From: Greg KH <gregkh@suse.de>
To: Andrei Warkentin <andreiw@motorola.com>
Cc: linux-kernel@vger.kernel.org, hjanssen@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH] HV SynthHID: Fix compile error.
Message-ID: <20110411192733.GB23059@suse.de>
References: <1302552092-8580-1-git-send-email-andreiw@motorola.com>
 <1302552092-8580-2-git-send-email-andreiw@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302552092-8580-2-git-send-email-andreiw@motorola.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 03:01:32PM -0500, Andrei Warkentin wrote:
> Missing include for <asm/delay.h>
> 
> Signed-off-by: Andrei Warkentin <andreiw@motorola.com>
> ---
>  drivers/staging/hv/hv_mouse.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> index 50147f8..c5020c0 100644
> --- a/drivers/staging/hv/hv_mouse.c
> +++ b/drivers/staging/hv/hv_mouse.c
> @@ -23,6 +23,7 @@
>  #include <linux/hiddev.h>
>  #include <linux/pci.h>
>  #include <linux/dmi.h>
> +#include <asm/delay.h>

Never include "<asm/" include files if at all possible.

Anyway, this should already be fixed in Linus's tree, right?

thanks,

greg k-h
