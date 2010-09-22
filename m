Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0IVDZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:25:53 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:34978 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0IVDZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:25:52 -0400
Date: Wed, 22 Sep 2010 13:25:46 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-m32r@ml.linux-m32r.org, linux-m68k@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-laptop@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/2 v3]Update broken web addresses.
In-Reply-To: <1285118957-24965-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1009221310500.4570@nippy.intranet>
References: <1285118957-24965-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Sep 2010, Justin P. Mattock wrote:

> Below is an update from the original, with changes to the broken web 
> addresses and removal of archive.org and moved to a seperate patch for 
> you guys to decide if you want to use this and/or just leave the old url 
> in and leave it at that..
> Please dont apply this to anything just comments and fixes for now,

You can use [RFC] in the Subject line instead of [PATCH] to indicate this.


> diff --git a/arch/m68k/mac/macboing.c b/arch/m68k/mac/macboing.c
> index 8f06408..234d9ee 100644
> --- a/arch/m68k/mac/macboing.c
> +++ b/arch/m68k/mac/macboing.c
> @@ -114,7 +114,8 @@ static void mac_init_asc( void )
>  			 *   16-bit I/O functionality.  The PowerBook 500 series computers
>  			 *   support 16-bit stereo output, but only mono input."
>  			 *
> -			 *   http://til.info.apple.com/techinfo.nsf/artnum/n16405
> +			 *   Article number 16405:
> +			 *   http://support.apple.com/kb/TA32601 
>  			 *
>  			 * --David Kilzer
>  			 */

"TIL article number 16405" would allow people to find the document by 
number...


> diff --git a/arch/m68k/q40/README b/arch/m68k/q40/README
> index 6bdbf48..92806c0 100644
> --- a/arch/m68k/q40/README
> +++ b/arch/m68k/q40/README
> @@ -3,7 +3,7 @@ Linux for the Q40
>  
>  You may try http://www.geocities.com/SiliconValley/Bay/2602/ for
>  some up to date information. Booter and other tools will be also
> -available from this place or ftp.uni-erlangen.de/linux/680x0/q40/
> +available from this place or http://www.linux-m68k.org/mail.html 
>  and mirrors.
>  
>  Hints to documentation usually refer to the linux source tree in

No. We already discussed this change. Please refer back to my review of 
the first version of the patch. You got it right in the second version 
(that I also reviewed), but now you've gone back to the first version...

Finn
