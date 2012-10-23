Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2JWWMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:12:05 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21779 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832Ab2JWWME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:12:04 -0400
X-IronPort-AV: E=Sophos;i="4.80,637,1344236400"; 
   d="scan'208";a="703415403"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Kees Cook <keescook@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 182/193] net/sunrpc: remove CONFIG_EXPERIMENTAL
Thread-Topic: [PATCH 182/193] net/sunrpc: remove CONFIG_EXPERIMENTAL
Thread-Index: AQHNsVnDJoRhLW8iBEqpeVsdKM/yBZfH6X0A
Date: Tue, 23 Oct 2012 22:12:01 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90928E1A6@SACEXCMBX04-PRD.hq.netapp.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-183-git-send-email-keescook@chromium.org>
In-Reply-To: <1351022666-6960-183-git-send-email-keescook@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DCF35D423767C4E85BE694A892CC283@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9NMC91d007181

On Tue, 2012-10-23 at 13:04 -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> CC: "J. Bruce Fields" <bfields@fieldses.org>
> CC: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/sunrpc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
> index 03d03e3..516fe2c 100644
> --- a/net/sunrpc/Kconfig
> +++ b/net/sunrpc/Kconfig
> @@ -10,7 +10,7 @@ config SUNRPC_BACKCHANNEL
>  
>  config SUNRPC_XPRT_RDMA
>  	tristate
> -	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
> +	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS
>  	default SUNRPC && INFINIBAND
>  	help
>  	  This option allows the NFS client and server to support

Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
