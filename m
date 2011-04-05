Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1DETIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:08:46 -0400
Received: from mail.perches.com ([173.55.12.10]:4512 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab1DETIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:08:43 -0400
Subject: Re: [PATCH] MAINTAINERS: Resend: Change mail adress of Hans J. Koch
From: Joe Perches <joe@perches.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110405185621.GE7028@local>
References: <20110405185621.GE7028@local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 12:08:40 -0700
Message-ID: <1302030520.3969.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 20:56 +0200, Hans J. Koch wrote:
> My old mail address doesn't exist anymore. This patch changes all occurences
> in MAINTAINERS to my new address. I already sent this in Oct. 2010, but it
> somehow never made it to mainline (is there a MAINTAINERS maintainer?)

The closest thing may be Andrew Morton.
I send my MAINTAINERS patches through him.
These patches are typically 1 release delayed.

$ ./scripts/get_maintainer.pl -f MAINTAINERS
Andrew Morton <akpm@linux-foundation.org> (commit_signer:79/549=14%)
Joe Perches <joe@perches.com> (commit_signer:50/549=9%)
linux-kernel@vger.kernel.org (open list)


> Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b4b9cd..b96f3b3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1063,7 +1063,7 @@ F:	arch/arm/mach-shmobile/
>  F:	drivers/sh/
>  
>  ARM/TELECHIPS ARM ARCHITECTURE
> -M:	"Hans J. Koch" <hjk@linutronix.de>
> +M:	"Hans J. Koch" <hjk@hansjkoch.de>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	arch/arm/plat-tcc/
> @@ -4077,7 +4077,7 @@ F:	drivers/video/matrox/matroxfb_*
>  F:	include/linux/matroxfb.h
>  
>  MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
> -M:	"Hans J. Koch" <hjk@linutronix.de>
> +M:	"Hans J. Koch" <hjk@hansjkoch.de>
>  L:	lm-sensors@lm-sensors.org
>  S:	Maintained
>  F:	Documentation/hwmon/max6650
> @@ -6618,7 +6618,7 @@ F:	fs/hostfs/
>  F:	fs/hppfs/
>  
>  USERSPACE I/O (UIO)
> -M:	"Hans J. Koch" <hjk@linutronix.de>
> +M:	"Hans J. Koch" <hjk@hansjkoch.de>
>  M:	Greg Kroah-Hartman <gregkh@suse.de>
>  S:	Maintained
>  F:	Documentation/DocBook/uio-howto.tmpl



