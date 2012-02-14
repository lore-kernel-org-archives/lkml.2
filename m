Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2BNRqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:46:32 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41297 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753322Ab2BNRq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:46:29 -0500
Message-ID: <4F3A9DD0.6030501@xenotime.net>
Date: Tue, 14 Feb 2012 09:45:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-doc@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] Documentation: Fix typo in kernel-parameters.txt
References: <1329233202-2576-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1329233202-2576-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 07:26 AM, Masanari Iida wrote:
> Correct spelling "mininum" to "minimum", "conroller" to "controller"
> and "explicitely" to "explicitly" in
> Documentation/kernel-parameters.txt
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  Documentation/kernel-parameters.txt |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 033d4e6..cfcc73f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -950,7 +950,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			     controller
>  	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
>  			     controllers
> -	i8042.notimeout	[HW] Ignore timeout condition signalled by conroller
> +	i8042.notimeout	[HW] Ignore timeout condition signalled by controller
>  	i8042.reset	[HW] Reset the controller during init and cleanup
>  	i8042.unlock	[HW] Unlock (ignore) the keylock
>  
> @@ -2434,7 +2434,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			For more information see Documentation/vm/slub.txt.
>  
>  	slub_min_order=	[MM, SLUB]
> -			Determines the mininum page order for slabs. Must be
> +			Determines the minimum page order for slabs. Must be
>  			lower than slub_max_order.
>  			For more information see Documentation/vm/slub.txt.
>  
> @@ -2600,7 +2600,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	threadirqs	[KNL]
>  			Force threading of all interrupt handlers except those
> -			marked explicitely IRQF_NO_THREAD.
> +			marked explicitly IRQF_NO_THREAD.
>  
>  	topology=	[S390]
>  			Format: {off | on}


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
