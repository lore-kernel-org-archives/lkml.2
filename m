Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932Ab2JWUaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:30:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:49339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933888Ab2JWUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:30:12 -0400
Message-ID: <5086FE52.3080803@kernel.dk>
Date: Tue, 23 Oct 2012 22:30:10 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 033/193] block: remove CONFIG_EXPERIMENTAL
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-34-git-send-email-keescook@chromium.org>
In-Reply-To: <1351022666-6960-34-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-23 22:01, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  block/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 09acf1b..a7e40a7 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -89,7 +89,7 @@ config BLK_DEV_INTEGRITY
>  
>  config BLK_DEV_THROTTLING
>  	bool "Block layer bio throttling support"
> -	depends on BLK_CGROUP=y && EXPERIMENTAL
> +	depends on BLK_CGROUP=y
>  	default n
>  	---help---
>  	Block layer bio throttling support. It can be used to limit

No worries on my end, EXPERIMENTAL seems to mean very little these days.
I have applied 33 and 38.

-- 
Jens Axboe

