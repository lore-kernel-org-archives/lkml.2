Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3ACJyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:54:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3ACJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:54:10 -0500
Date: Thu, 3 Jan 2013 10:54:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "Documentation: ABI:
 /sys/devices/system/cpu/cpu#/node"
In-Reply-To: <20130103094321.0719E3E403B@msa101.auone-net.jp>
Message-ID: <alpine.LNX.2.00.1301031054000.27348@pobox.suse.cz>
References: <20130103094321.0719E3E403B@msa101.auone-net.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2013, Kusanagi Kouichi wrote:

> This reverts commit cba5dd7fa535b7684cba68e17ac8be5b0083dc3d.
> 
> Commit cba5dd7fa535b7684cba68e17ac8be5b0083dc3d duplicates
> /sys/devices/system/cpu/cpu#/node entry.
> Commit 657348a056eea4a27be20cf8e22c98a252597447 has already added it.
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>

Applied.

> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu |   14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 6943133..9c978dc 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -67,20 +67,6 @@ Description:	Discover NUMA node a CPU belongs to
>  		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
>  
>  
> -What:		/sys/devices/system/cpu/cpu#/node
> -Date:		October 2009
> -Contact:	Linux memory management mailing list <linux-mm@kvack.org>
> -Description:	Discover NUMA node a CPU belongs to
> -
> -		When CONFIG_NUMA is enabled, a symbolic link that points
> -		to the corresponding NUMA node directory.
> -
> -		For example, the following symlink is created for cpu42
> -		in NUMA node 2:
> -
> -		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
> -
> -
>  What:		/sys/devices/system/cpu/cpu#/topology/core_id
>  		/sys/devices/system/cpu/cpu#/topology/core_siblings
>  		/sys/devices/system/cpu/cpu#/topology/core_siblings_list
> -- 
> 1.7.10.4
> 

-- 
Jiri Kosina
SUSE Labs
