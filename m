Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1JaG21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:28:27 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:46760 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab1JaG20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:28:26 -0400
Message-ID: <4EAE3FF7.9000302@st.com>
Date: Mon, 31 Oct 2011 11:58:07 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] pcie-gadget-spear: Add "platform:" prefix for platform
 modalias
References: <1320027628.2690.1.camel@phoenix>
In-Reply-To: <1320027628.2690.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 7:50 AM, Axel Lin wrote:
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
> with "platform:"), the platform modalias is prefixed with "platform:".
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/misc/spear13xx_pcie_gadget.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
> index cfbddbe..43d073b 100644
> --- a/drivers/misc/spear13xx_pcie_gadget.c
> +++ b/drivers/misc/spear13xx_pcie_gadget.c
> @@ -903,6 +903,6 @@ static void __exit spear_pcie_gadget_exit(void)
>   }
>   module_exit(spear_pcie_gadget_exit);
>
> -MODULE_ALIAS("pcie-gadget-spear");
> +MODULE_ALIAS("platform:pcie-gadget-spear");
>   MODULE_AUTHOR("Pratyush Anand");
>   MODULE_LICENSE("GPL");

Acked-by: Pratyush Anand<pratyush.anand@st.com>
