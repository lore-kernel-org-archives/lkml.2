Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab1IIP3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:29:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759184Ab1IIP3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:29:15 -0400
Date: Fri, 9 Sep 2011 08:25:33 -0700
From: Greg KH <gregkh@suse.de>
To: Olaf Hering <olaf@aepfle.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH] Staging: hv: storvsc: advertise hv_storvsc instead of
 storvsc as driver name
Message-ID: <20110909152533.GB26556@suse.de>
References: <20110908162650.GA10699@aepfle.de>
 <20110909124533.GA23598@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909124533.GA23598@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 02:45:33PM +0200, Olaf Hering wrote:
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -42,6 +42,8 @@
>  
>  #include "hyperv.h"
>  
> +#define MODULE_NAME "hv_storvsc"

No, just use KBUILD_MODNAME, it's already there and correct.  Care to
fix this one, and your other patch, to use it instead?

thanks,

greg k-h
