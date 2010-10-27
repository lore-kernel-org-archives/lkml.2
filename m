Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0J0Bjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:39:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:57256 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0J0Bje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:39:34 -0400
Message-ID: <4CC7821E.9070503@windriver.com>
Date: Tue, 26 Oct 2010 20:36:30 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        David Airlie <airlied@linux.ie>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCH] documentation: update sysrq.txt magic sysrq keys
References: <20101026142040.2f0b70a1.randy.dunlap@oracle.com>
In-Reply-To: <20101026142040.2f0b70a1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 01:36:31.0576 (UTC) FILETIME=[61FD9D80:01CB7577]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Jason Wessel <jason.wessel@windriver.com>

If you take a look at commit: 364b5b7b1d793a7f98be55b6b154716dcae78dfc,
the voyager and kgdb bits were originally fixed there.  It was not
obvious to me at the time that this was documented in multiple places,
else it would have been fixed in the same commit.

Cheers,
Jason.

On 10/26/2010 04:20 PM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Update Documentation/sysrq.txt magic sysrq keys:
>
> - 'g' is for kgdb (not arch-specific);
> - add 2 new uses for 'v', remove the Voyager info;
> - add 'y' info (SPARC-64 specific);
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Jason Wessel <jason.wessel@windriver.com>
> Cc:	"David S. Miller" <davem@davemloft.net>
> Cc:	"James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc:	David Airlie <airlied@linux.ie>
> Acked-by: Alexander Shishkin <virtuoso@slind.org>
> ---
>  Documentation/sysrq.txt |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> --- lnx-2636-g6-docs.orig/Documentation/sysrq.txt
> +++ lnx-2636-g6-docs/Documentation/sysrq.txt
> @@ -75,7 +75,7 @@ On all -  write a character to /proc/sys
>  
>  'f'	- Will call oom_kill to kill a memory hog process.
>  
> -'g'	- Used by kgdb on ppc and sh platforms.
> +'g'	- Used by kgdb (kernel debugger)
>  
>  'h'     - Will display help (actually any other key than those listed
>            here will display help. but 'h' is easy to remember :-)
> @@ -110,12 +110,15 @@ On all -  write a character to /proc/sys
>  
>  'u'     - Will attempt to remount all mounted filesystems read-only.
>  
> -'v'	- Dumps Voyager SMP processor info to your console.
> +'v'	- Forcefully restores framebuffer console
> +'v'	- Causes ETM buffer dump [ARM-specific]
>  
>  'w'	- Dumps tasks that are in uninterruptable (blocked) state.
>  
>  'x'	- Used by xmon interface on ppc/powerpc platforms.
>  
> +'y'	- Show global CPU Registers [SPARC-64 specific]
> +
>  'z'	- Dump the ftrace buffer
>  
>  '0'-'9' - Sets the console log level, controlling which kernel messages
>   

