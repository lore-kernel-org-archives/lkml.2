Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2AWIzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 03:55:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:52883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2AWIzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 03:55:11 -0500
Message-ID: <1327308902.2442.256.camel@twins>
Subject: Re: [PATCH 14/14] docbook: fix sched source file names in
 device-drivers book
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 23 Jan 2012 09:55:02 +0100
In-Reply-To: <4F1B0BFC.2010105@xenotime.net>
References: <4F1B0BFC.2010105@xenotime.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-21 at 11:03 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix warning since kernel scheduler functions and kernel-doc
> notation were moved to other files.
> 
> docproc: lnx-33-rc1/kernel/sched.c: No such file or directory
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  Documentation/DocBook/device-drivers.tmpl |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- lnx-33-rc1.orig/Documentation/DocBook/device-drivers.tmpl
> +++ lnx-33-rc1/Documentation/DocBook/device-drivers.tmpl
> @@ -50,7 +50,9 @@
>  
>       <sect1><title>Delaying, scheduling, and timer routines</title>
>  !Iinclude/linux/sched.h
> -!Ekernel/sched.c
> +!Ekernel/sched/core.c
> +!Ikernel/sched/cpupri.c
> +!Ikernel/sched/fair.c

There's more files in there, they might not include proper kerneldoc
comments, but shouldn't they be included anyway?

Also, what the difference between Ekernel and Ikernel?

>  !Iinclude/linux/completion.h
>  !Ekernel/timer.c
>       </sect1>



