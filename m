Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2GRCoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:44:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47555 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2GRCoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:44:06 -0400
Message-ID: <500622F2.1060808@landley.net>
Date: Tue, 17 Jul 2012 21:44:02 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jovi Zhang <bookjovi@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, srikar@linux.vnet.ibm.com
Subject: Re: uprobes: fix uprobe tracer wrong documentation
References: <CACV3sb+mHoxLWtEGbxzGQ8Lfn2JDc5F=PNMMfmU2Ayw4-JHb+w@mail.gmail.com>
In-Reply-To: <CACV3sb+mHoxLWtEGbxzGQ8Lfn2JDc5F=PNMMfmU2Ayw4-JHb+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 03:49 AM, Jovi Zhang wrote:
> From e382d2d14b8177bcd2e6bac2fee004fd1f052cb5 Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com <mailto:bookjovi@gmail.com>>
> Date: Tue, 17 Jul 2012 00:35:30 +0800
> Subject: [PATCH] uprobes: fix uprobe tracer wrong documentation
> 
> The uprobe example is wrong in current kernel:
> $ echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> -bash: echo: write error: Invalid argument
> 
> It should be as following:
> $ echo 'p /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com <mailto:bookjovi@gmail.com>>
> ---
>  Documentation/trace/uprobetracer.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/trace/uprobetracer.txt
> b/Documentation/trace/uprobetracer.txt
> index 24ce682..8932726 100644
> --- a/Documentation/trace/uprobetracer.txt
> +++ b/Documentation/trace/uprobetracer.txt
> @@ -40,7 +40,7 @@ Usage examples
>  To add a probe as a new event, write a new definition to uprobe_events
>  as below.
>  
> -  echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
> +  echo 'p /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
>  
>   This sets a uprobe at an offset of 0x4245c0 in the executable /bin/bash

Acked. Tracking, and I'll forward if nobody else pipes up before the
merge window opens.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
