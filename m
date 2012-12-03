Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2LCKMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:12:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab2LCKMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:12:17 -0500
Date: Mon, 3 Dec 2012 11:12:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Hyeonjun Lim <hjoon0510@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Doc: Update the naming of profiling based on sysfs
In-Reply-To: <1354516291-15589-1-git-send-email-hjoon0510@gmail.com>
Message-ID: <alpine.LNX.2.00.1212031112010.27624@pobox.suse.cz>
References: <1354516291-15589-1-git-send-email-hjoon0510@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012, Hyeonjun Lim wrote:

> We setup and run 'profiling' feature under Linux system.
> The readprofile(1) command uses the /proc/profile information
> to display ascii data on standard output.
> sort -nr | head -5
> 
> /proc/profile correctly. The ./kernel/ksysfs.c defines 'profiling'
> w/o 'profile' like "KERNEL_ATTR_RW(profiling)".
> We need to synchronize the content between ksys.c source and kernel doc. 
> 
> Signed-off-by: Hyeonjun Lim <hjoon0510@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-profiling |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-profiling b/Documentation/ABI/testing/sysfs-profiling
> index b02d8b8..8a8e466 100644
> --- a/Documentation/ABI/testing/sysfs-profiling
> +++ b/Documentation/ABI/testing/sysfs-profiling
> @@ -1,13 +1,13 @@
> -What:		/sys/kernel/profile
> +What:		/sys/kernel/profiling
>  Date:		September 2008
>  Contact:	Dave Hansen <dave@linux.vnet.ibm.com>
>  Description:
> -		/sys/kernel/profile is the runtime equivalent
> +		/sys/kernel/profiling is the runtime equivalent
>  		of the boot-time profile= option.
>  
>  		You can get the same effect running:
>  
> -			echo 2 > /sys/kernel/profile
> +			echo 2 > /sys/kernel/profiling
>  
>  		as you would by issuing profile=2 on the boot
>  		command line.

I am applying this one, thanks.

-- 
Jiri Kosina
SUSE Labs
