Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2LQQRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:17:23 -0500
Received: from mail.vyatta.com ([76.74.103.46]:52282 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab2LQQRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:17:22 -0500
Date: Mon, 17 Dec 2012 08:16:05 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] ip: add the type 'vxlan' in the output of "ip link
 help"
Message-ID: <20121217081605.7e2ed94b@nehalam.linuxnetplumber.net>
In-Reply-To: <1355588468-4964-1-git-send-email-zwu.kernel@gmail.com>
References: <1355588468-4964-1-git-send-email-zwu.kernel@gmail.com>
Organization: Vyatta
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2012 00:21:08 +0800
zwu.kernel@gmail.com wrote:

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   The new type 'vxlan' is added in the output of "ip link help"
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  ip/iplink.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/ip/iplink.c b/ip/iplink.c
> index d73c705..5ff8f85 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -84,7 +84,7 @@ void iplink_usage(void)
>  	if (iplink_have_newlink()) {
>  		fprintf(stderr, "\n");
>  		fprintf(stderr, "TYPE := { vlan | veth | vcan | dummy | ifb | macvlan | can |\n");
> -		fprintf(stderr, "          bridge | ipoib | ip6tnl | ipip | sit }\n");
> +		fprintf(stderr, "          bridge | ipoib | ip6tnl | ipip | sit | vxlan }\n");
>  	}
>  	exit(-1);
>  }

Applied
