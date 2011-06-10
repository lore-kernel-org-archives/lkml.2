Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1FJMgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:36:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:52375 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab1FJMf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:35:59 -0400
Date: Fri, 10 Jun 2011 14:35:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/Trivial] Update feature-removal-update.txt with 3.x
 versioning
In-Reply-To: <20110609220303.GA2612@plexity.net>
Message-ID: <alpine.LNX.2.00.1106101434210.22872@pobox.suse.cz>
References: <20110609220303.GA2612@plexity.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Deepak Saxena wrote:

> 
> Update feature removal schedule with 3.x numbering
>  
> Update all future kernel version entries in feature-removal-schedule.txt
> with appropriate 3.x kernel numbering.
>     
> Signed-off-by: Deepak Saxena <dsaxena@plexity.net>
> 
> ---
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 1a9446b..7725792 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -199,7 +199,7 @@ Files:	drivers/staging/cs5535_gpio/*
>  Check:	drivers/staging/cs5535_gpio/cs5535_gpio.c
>  Why:	A newer driver replaces this; it is drivers/gpio/cs5535-gpio.c, and
>  	integrates with the Linux GPIO subsystem.  The old driver has been
> -	moved to staging, and will be removed altogether around 2.6.40.
> +	moved to staging, and will be removed altogether around 3.0.
>  	Please test the new driver, and ensure that the functionality you
>  	need and any bugfixes from the old driver are available in the new
>  	one.
> @@ -430,7 +430,7 @@ Who:	Avi Kivity <avi@redhat.com>
>  ----------------------------
>  
>  What:	iwlwifi 50XX module parameters
> -When:	2.6.40
> +When:	3.0
>  Why:	The "..50" modules parameters were used to configure 5000 series and
>  	up devices; different set of module parameters also available for 4965
>  	with same functionalities. Consolidate both set into single place
> @@ -441,7 +441,7 @@ Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
>  ----------------------------
>  
>  What:	iwl4965 alias support
> -When:	2.6.40
> +When:	3.0
>  Why:	Internal alias support has been present in module-init-tools for some
>  	time, the MODULE_ALIAS("iwl4965") boilerplate aliases can be removed
>  	with no impact.
> @@ -499,7 +499,7 @@ Who:    Daniel Lezcano <daniel.lezcano@free.fr>
>  ----------------------------
>  
>  What:	iwlwifi disable_hw_scan module parameters
> -When:	2.6.40
> +When:	3.0
>  Why:	Hareware scan is the prefer method for iwlwifi devices for
>  	scanning operation. Remove software scan support for all the
>  	iwlwifi devices.
> @@ -510,7 +510,7 @@ Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
>  
>  What:   access to nfsd auth cache through sys_nfsservctl or '.' files
>          in the 'nfsd' filesystem.
> -When:   2.6.40
> +When:   3.0
>  Why:    This is a legacy interface which have been replaced by a more
>          dynamic cache.  Continuing to maintain this interface is an
>          unnecessary burden.
> @@ -546,7 +546,7 @@ Files:	net/netfilter/xt_connlimit.c
>  ----------------------------
>  
>  What:	noswapaccount kernel command line parameter
> -When:	2.6.40
> +When:	3.0
>  Why:	The original implementation of memsw feature enabled by
>  	CONFIG_CGROUP_MEM_RES_CTLR_SWAP could be disabled by the noswapaccount
>  	kernel parameter (introduced in 2.6.29-rc1). Later on, this decision
> @@ -579,7 +579,7 @@ Who:	Jean Delvare <khali@linux-fr.org>
>  ----------------------------
>  
>  What:	Support for UVCIOC_CTRL_ADD in the uvcvideo driver
> -When:	2.6.42
> +When:	3.2
>  Why:	The information passed to the driver by this ioctl is now queried
>  	dynamically from the device.
>  Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> @@ -587,7 +587,7 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  ----------------------------
>  
>  What:	Support for UVCIOC_CTRL_MAP_OLD in the uvcvideo driver
> -When:	2.6.42
> +When:	3.2
>  Why:	Used only by applications compiled against older driver versions.
>  	Superseded by UVCIOC_CTRL_MAP which supports V4L2 menu controls.
>  Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> @@ -595,7 +595,7 @@ Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  ----------------------------
>  
>  What:	Support for UVCIOC_CTRL_GET and UVCIOC_CTRL_SET in the uvcvideo driver
> -When:	2.6.42
> +When:	3.2

If I understand it correctly, we might end up with 3.x.0 scheme at the end 
of the day, because of depmod incompatibility.

-- 
Jiri Kosina
SUSE Labs
