Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab1ECR6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:58:22 -0400
Received: from kroah.org ([198.145.64.141]:38036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1ECR6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:58:07 -0400
Date: Tue, 3 May 2011 10:57:03 -0700
From: Greg KH <greg@kroah.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, hjanssen@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH] staging: hv: make HYPERV_UTILS depend on NLS to prevent
 a build error
Message-ID: <20110503175703.GA19082@kroah.com>
References: <4DB60932.6090000@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB60932.6090000@verizon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 07:52:18PM -0400, Peter Foley wrote:
> This patch adds a dependency on NLS to HYPERV_UTILS to avoid a build error.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  drivers/staging/hv/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
> index d41f380..76f0756 100644
> --- a/drivers/staging/hv/Kconfig
> +++ b/drivers/staging/hv/Kconfig
> @@ -31,7 +31,7 @@ config HYPERV_NET
>   config HYPERV_UTILS
>  	tristate "Microsoft Hyper-V Utilities driver"
> -	depends on CONNECTOR
> +	depends on CONNECTOR && NLS

This patch doesn't apply at all, and I can't figure out why.  Did your
email client somehow mess it up?

Care to resend it, with the proper information in the Changelog entry
(i.e. what build error this is fixing) so I can apply it?

thanks,

greg k-h
