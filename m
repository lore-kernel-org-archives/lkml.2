Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0IVKMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:12:19 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:36351 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0IVKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:12:18 -0400
Date: Wed, 22 Sep 2010 13:05:20 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] documentation: update sysrq.txt key mappings
Message-ID: <20100922100519.GD10463@shisha.kicks-ass.net>
References: <20100921160142.7c783105.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921160142.7c783105.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 04:01:42 -0700, Randy Dunlap wrote:
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
> Cc:	Alexander Shishkin <virtuoso@slind.org>

Acked-by: Alexander Shishkin <virtuoso@slind.org>

> ---
>  Documentation/sysrq.txt |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- lnx-2636-rc5.orig/Documentation/sysrq.txt
> +++ lnx-2636-rc5/Documentation/sysrq.txt
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
