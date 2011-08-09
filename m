Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HIOlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:41:39 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3984 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1HIOli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:41:38 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH net-next 2/2] bnx2x: Coalesce pr_cont uses and fix
 DP typos
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Joe Perches" <joe@perches.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <98d09e1b3d7a73bf5f2744f0ca238321573e4579.1312818707.git.joe@perches.com>
References: <cover.1312818707.git.joe@perches.com>
 <98d09e1b3d7a73bf5f2744f0ca238321573e4579.1312818707.git.joe@perches.com>
Organization: Broadcom
Date: Tue, 9 Aug 2011 17:41:23 +0300
Message-ID: <1312900883.31417.2.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 625F97E53DK9349361-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 08:53 -0700, Joe Perches wrote:
> Uses of pr_cont should be avoided where reasonably possible
> because they can be interleaved by other threads and processes.
> 
> Coalesce pr_cont uses.
> 
> Fix typos, duplicated words and spacing in DP uses caused
> by split multi-line formats.  Coalesce some of these
> split formats.  Add missing terminating newlines to DP uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

....

> @@ -12254,7 +12261,7 @@ void bnx2x_period_func(struct link_params *params, struct link_vars *vars)
>  {
>         struct bnx2x *bp = params->bp;
>         if (!params) {
> -               DP(NETIF_MSG_LINK, "Ininitliazed params !\n");
> +               DP(NETIF_MSG_LINK, "Uninitialized params !\n");
>                 return;
>         }
>         /* DP(NETIF_MSG_LINK, "Periodic called vars->phy_flags 0x%x speed 0x%x

This does not apply on the current net-next. Other than that - it looks
good.

Please re-submit this patch series once net-next is opened for driver
changes (see: http://marc.info/?l=linux-netdev&m=131278578427946&w=2 )
and I will ACK it.

Thanks,
Eilon


