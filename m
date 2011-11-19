Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1KSNoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 08:44:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab1KSNoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 08:44:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] kernel/power/main.c : Fix indentation and remove extraneous whitespaces
Date: Sat, 19 Nov 2011 14:46:53 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20111119091233.27293.34295.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111119091233.27293.34295.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111191446.53849.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 19, 2011, Srivatsa S. Bhat wrote:
> Lack of proper indentation of the goto statement decreases the readability
> of code significantly. In fact, this made me look twice at the code to check
> whether it really does what it should be doing. Fix this.
> 
> And in the same file, there are some extra whitespaces. Get rid of them too.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  kernel/power/main.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 71f49fe..670fb08 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -3,7 +3,7 @@
>   *
>   * Copyright (c) 2003 Patrick Mochel
>   * Copyright (c) 2003 Open Source Development Lab
> - * 
> + *
>   * This file is released under the GPLv2
>   *
>   */
> @@ -240,7 +240,7 @@ struct kobject *power_kobj;
>   *	'standby' (Power-On Suspend), 'mem' (Suspend-to-RAM), and
>   *	'disk' (Suspend-to-Disk).
>   *
> - *	store() accepts one of those strings, translates it into the 
> + *	store() accepts one of those strings, translates it into the
>   *	proper enumerated value, and initiates a suspend transition.
>   */
>  static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
> @@ -282,7 +282,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	/* First, check if we are requested to hibernate */
>  	if (len == 4 && !strncmp(buf, "disk", len)) {
>  		error = hibernate();
> -  goto Exit;
> +		goto Exit;
>  	}
>  
>  #ifdef CONFIG_SUSPEND
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

