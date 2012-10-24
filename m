Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986Ab2JXOd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:33:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60950 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934903Ab2JXOdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:33:25 -0400
Message-ID: <5087FC33.10906@gmail.com>
Date: Wed, 24 Oct 2012 10:33:23 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 181/193] net/sctp: remove CONFIG_EXPERIMENTAL
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-182-git-send-email-keescook@chromium.org>
In-Reply-To: <1351022666-6960-182-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 04:04 PM, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>
> CC: Vlad Yasevich <vyasevich@gmail.com>
> CC: Sridhar Samudrala <sri@us.ibm.com>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

> ---
>   net/sctp/Kconfig |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
> index 126b014..0e13f54 100644
> --- a/net/sctp/Kconfig
> +++ b/net/sctp/Kconfig
> @@ -3,8 +3,8 @@
>   #
>
>   menuconfig IP_SCTP
> -	tristate "The SCTP Protocol (EXPERIMENTAL)"
> -	depends on INET && EXPERIMENTAL
> +	tristate "The SCTP Protocol"
> +	depends on INET
>   	depends on IPV6 || IPV6=n
>   	select CRYPTO
>   	select CRYPTO_HMAC
>

