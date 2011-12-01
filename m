Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1LAWE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:04:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab1LAWEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:04:55 -0500
Date: Thu, 1 Dec 2011 14:04:31 -0800
From: Greg KH <gregkh@suse.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Update MAINTAINERS
Message-ID: <20111201220431.GA3261@suse.de>
References: <1322776486-17077-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322776486-17077-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 01:54:46PM -0800, K. Y. Srinivasan wrote:
> Update the MAINTAINERS file to reflect the current state
> of the Hyper-V drivers.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  MAINTAINERS |   25 +++++++++++++++++++++++--
>  1 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3523ab0..db6cee2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3197,6 +3197,27 @@ M:	William Irwin <wli@holomorphy.com>
>  S:	Maintained
>  F:	fs/hugetlbfs/
>  
> +Hyper-V CORE DRIVERS
> +M:	K. Y. Srinivasan <kys@microsoft.com>
> +M:	Haiyang Zhang <haiyangz@microsoft.com>
> +L:	devel@linuxdriverproject.org
> +S:	Maintained
> +F:	drivers/hv/
> +
> +Hyper-V MOUSE DRIVER
> +M:	K. Y. Srinivasan <kys@microsoft.com>
> +M:	Haiyang Zhang <haiyangz@microsoft.com>
> +L:	devel@linuxdriverproject.org
> +S:	Maintained
> +F:	drivers/hid/hid-hyperv.c
> +
> +Hyper-V NETWORK DRIVER
> +M:	K. Y. Srinivasan <kys@microsoft.com>
> +M:	Haiyang Zhang <haiyangz@microsoft.com>
> +L:	devel@linuxdriverproject.org
> +S:	Maintained
> +F:	drivers/net/hyperv/

This whole patch could all be consolidated into one entry, that also
fixes the name of the subsystem to follow the rest of the file format:

HYPER-V CORE AND DRIVERS
M:	K. Y. Srinivasan <kys@microsoft.com>
M:	Haiyang Zhang <haiyangz@microsoft.com>
L:	devel@linuxdriverproject.org
S:	Maintained
F:	drivers/hv/
F:	drivers/hid/hid-hyperv.c
F:	drivers/net/hyperv/
F:	drivers/staging/hv/

Care to redo this?

thanks,

greg k-h
