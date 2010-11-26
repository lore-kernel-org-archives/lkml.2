Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0KZWFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:05:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0KZWFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:05:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tracey Dent <tdent48227@gmail.com>
Subject: Re: [PATCH] kernel/power/: Changed Makefile to use proper ccflag flag
Date: Fri, 26 Nov 2010 23:04:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: len.brown@intel.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org
References: <1289690914-3752-1-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1289690914-3752-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201011262305.00086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 14, 2010, Tracey Dent wrote:
> Use the ccflags-$ flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
> deprecated and should now be switched. According to (documentation/kbuild/makefiles.txt).

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
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
> 

