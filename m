Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0ERL7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:59:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab0ERL7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:59:34 -0400
Date: Tue, 18 May 2010 13:59:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] HID: Removing/Renaming preprocessor macros for Roccat
 Kone
In-Reply-To: <1273679014.2927.4.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005181359041.28092@pobox.suse.cz>
References: <1273679014.2927.4.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, Stefan Achatz wrote:

> >From a50a004999d4bd2b9ae08f1298b1fc89ce9e1e12 Mon Sep 17 00:00:00 2001
> From: Stefan Achatz <erazor_de@users.sourceforge.net>
> Date: Sat, 8 May 2010 16:34:05 +0200
> Subject: [PATCH 1/5] HID: Removing/Renaming preprocessor macros for Roccat Kone
> 
> Removed useless preprocessor macros and renamed remaining one to be
> more qualified.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  drivers/hid/hid-roccat-kone.c |    8 ++++----
>  drivers/hid/hid-roccat-kone.h |    5 +----
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> index 7b11784..d23d309 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -630,7 +630,7 @@ static ssize_t kone_sysfs_set_startup_profile(struct device *dev,
>  static ssize_t kone_sysfs_show_driver_version(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> -	return snprintf(buf, PAGE_SIZE, DRIVER_VERSION "\n");
> +	return snprintf(buf, PAGE_SIZE, ROCCAT_KONE_DRIVER_VERSION "\n");
>  }
>  
>  /*
> @@ -1002,6 +1002,6 @@ static void kone_exit(void)
>  module_init(kone_init);
>  module_exit(kone_exit);
>  
> -MODULE_AUTHOR(DRIVER_AUTHOR);
> -MODULE_DESCRIPTION(DRIVER_DESC);
> -MODULE_LICENSE(DRIVER_LICENSE);
> +MODULE_AUTHOR("Stefan Achatz");
> +MODULE_DESCRIPTION("USB Roccat Kone driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
> index ee6898c..99290ad 100644
> --- a/drivers/hid/hid-roccat-kone.h
> +++ b/drivers/hid/hid-roccat-kone.h
> @@ -14,10 +14,7 @@
>  
>  #include <linux/types.h>
>  
> -#define DRIVER_VERSION "v0.3.0"
> -#define DRIVER_AUTHOR "Stefan Achatz"
> -#define DRIVER_DESC "USB Roccat Kone driver"
> -#define DRIVER_LICENSE "GPL v2"
> +#define ROCCAT_KONE_DRIVER_VERSION "v0.3.1"

Why do we need this? git is much better tracking revisions than humans, 
who usually forget to update the defines anyway ...

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
