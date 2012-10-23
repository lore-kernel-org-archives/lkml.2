Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab2JWWiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:38:20 -0400
Received: from void.printf.net ([89.145.121.20]:37932 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933560Ab2JWWiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:38:19 -0400
From: Chris Ball <cjb@laptop.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 070/193] drivers/mmc/core: remove CONFIG_EXPERIMENTAL
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-71-git-send-email-keescook@chromium.org>
Date: Tue, 23 Oct 2012 18:38:14 -0400
In-Reply-To: <1351022666-6960-71-git-send-email-keescook@chromium.org> (Kees
	Cook's message of "Tue, 23 Oct 2012 13:02:23 -0700")
Message-ID: <876260hl0p.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 23 2012, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: Chris Ball <cjb@laptop.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/mmc/core/Kconfig |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
> index ef10387..269d072 100644
> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -18,8 +18,7 @@ config MMC_UNSAFE_RESUME
>  	  module parameter "removable=0" or "removable=1".
>  
>  config MMC_CLKGATE
> -	bool "MMC host clock gating (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	bool "MMC host clock gating"
>  	help
>  	  This will attempt to aggressively gate the clock to the MMC card.
>  	  This is done to save power due to gating off the logic and bus

Maybe this isn't important, but:

I think the commit message should be changed -- this part of the series
doesn't remove EXPERIMENTAL, it removes the dependency on it from its
current users.  The way the commit message is worded makes it sound like
the patch is going to remove MMC_CLKGATE, which of course it doesn't.

Ditto the subject line, could be ": remove use of CONFIG_EXPERIMENTAL".

Regardless, for this and the subsequent [071] patch:

Acked-by: Chris Ball <cjb@laptop.org>

(Let me know if you'd like me to take these, I don't mind who merges them.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
