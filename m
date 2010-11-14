Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0KNFc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:32:28 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53549 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751100Ab0KNFc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:32:27 -0500
Date: Sun, 14 Nov 2010 06:32:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tracey Dent <tdent48227@gmail.com>
Cc: len.brown@intel.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/power/: Changed Makefile to use proper ccflag
 flag
Message-ID: <20101114053210.GC2189@elf.ucw.cz>
References: <1289690914-3752-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289690914-3752-1-git-send-email-tdent48227@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-11-13 18:28:34, Tracey Dent wrote:
> Use the ccflags-$ flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
> deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

ACK.

> ---
>  kernel/power/Makefile |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/power/Makefile b/kernel/power/Makefile
> index f9063c6..b755972 100644
> --- a/kernel/power/Makefile
> +++ b/kernel/power/Makefile
> @@ -1,7 +1,4 @@
> -
> -ifeq ($(CONFIG_PM_DEBUG),y)
> -EXTRA_CFLAGS	+=	-DDEBUG
> -endif
> +ccflags-$(CONFIG_PM_DEBUG)	:=	-DDEBUG
>  
>  obj-$(CONFIG_PM)		+= main.o
>  obj-$(CONFIG_PM_SLEEP)		+= console.o

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
