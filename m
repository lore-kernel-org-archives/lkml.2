Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2KPKQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:16:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32865 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2KPKQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:16:53 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A6127D.10203@jp.fujitsu.com>
Date: Fri, 16 Nov 2012 19:16:29 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Jim Paris <jim@jtan.com>
Subject: Re: [PATCH] Correct description of SwapFree in Documentation/filesystems/proc.txt
References: <50A5E4D6.60301@gmail.com>
In-Reply-To: <50A5E4D6.60301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/16 16:01), Michael Kerrisk wrote:
> After migrating most of the information in
> Documentation/filesystems/proc.txt to the proc(5) man page,
> Jim Paris pointed out to me that the description of SwapFree
> in the man page seemed wrong. I think Jim is right,
> but am given pause by fact that that text has been in
> Documentation/filesystems/proc.txt since at least 2.6.0.
> Anyway, I believe that the patch below fixes things.
>
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

>
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index a1793d6..cf4260f 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -778,8 +778,7 @@ AnonHugePages:   49152 kB
>                 other things, it is where everything from the Slab is
>                 allocated.  Bad things happen when you're out of lowmem.
>      SwapTotal: total amount of swap space available
> -    SwapFree: Memory which has been evicted from RAM, and is temporarily
> -              on the disk
> +    SwapFree: Amount of swap space that is currently unused.
>          Dirty: Memory which is waiting to get written back to the disk
>      Writeback: Memory which is actively being written back to the disk
>      AnonPages: Non-file backed pages mapped into userspace page tables
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


