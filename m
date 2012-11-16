Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab2KPKKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:10:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2KPKKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:10:13 -0500
Date: Fri, 16 Nov 2012 11:10:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Jim Paris <jim@jtan.com>
Subject: Re: [PATCH] Correct description of SwapFree in
 Documentation/filesystems/proc.txt
Message-ID: <20121116101008.GA2011@dhcp22.suse.cz>
References: <50A5E4D6.60301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A5E4D6.60301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-11-12 08:01:42, Michael Kerrisk wrote:
> After migrating most of the information in 
> Documentation/filesystems/proc.txt to the proc(5) man page,
> Jim Paris pointed out to me that the description of SwapFree
> in the man page seemed wrong. I think Jim is right,
> but am given pause by fact that that text has been in 
> Documentation/filesystems/proc.txt since at least 2.6.0.
> Anyway, I believe that the patch below fixes things.

Yes, this goes back to 2003 when the /proc/meminfo doc has been added.

> 
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index a1793d6..cf4260f 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -778,8 +778,7 @@ AnonHugePages:   49152 kB
>                other things, it is where everything from the Slab is
>                allocated.  Bad things happen when you're out of lowmem.
>     SwapTotal: total amount of swap space available
> -    SwapFree: Memory which has been evicted from RAM, and is temporarily
> -              on the disk
> +    SwapFree: Amount of swap space that is currently unused.
>         Dirty: Memory which is waiting to get written back to the disk
>     Writeback: Memory which is actively being written back to the disk
>     AnonPages: Non-file backed pages mapped into userspace page tables
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
