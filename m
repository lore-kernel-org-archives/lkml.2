Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1LBObq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:31:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1LBObp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:31:45 -0500
Date: Fri, 2 Dec 2011 15:31:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Update MAINTAINERS
In-Reply-To: <1322778690-17381-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LNX.2.00.1112021531230.18207@pobox.suse.cz>
References: <1322778690-17381-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, K. Y. Srinivasan wrote:

> Update the MAINTAINERS file to reflect the current state
> of the Hyper-V drivers.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  MAINTAINERS |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3523ab0..809cad8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3197,6 +3197,16 @@ M:	William Irwin <wli@holomorphy.com>
>  S:	Maintained
>  F:	fs/hugetlbfs/
>  
> +Hyper-V CORE AND DRIVERS
> +M:	K. Y. Srinivasan <kys@microsoft.com>
> +M:	Haiyang Zhang <haiyangz@microsoft.com>
> +L:	devel@linuxdriverproject.org
> +S:	Maintained
> +F:	drivers/hv/
> +F:	drivers/hid/hid-hyperv.c
> +F:	drivers/net/hyperv/
> +F:	drivers/staging/hv/
> +

I will be taking this through trivial tree. Thanks,

-- 
Jiri Kosina
SUSE Labs
