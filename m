Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1ADRK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:10:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58950 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1ADRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:10:25 -0500
Date: Tue, 4 Jan 2011 09:10:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: [PATCH -next] thermal: depends on NET
Message-Id: <20110104091006.159f1c9c.randy.dunlap@oracle.com>
In-Reply-To: <20101213112033.d0060e6c.randy.dunlap@oracle.com>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
	<20101213112033.d0060e6c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010 11:20:33 -0800 Randy Dunlap wrote:

This patch is still needed in linux-next 20110104.


> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ERROR: "genl_register_family" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "genl_unregister_family" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "init_net" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "__alloc_skb" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "netlink_broadcast" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "kfree_skb" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "genl_register_mc_group" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "nla_reserve" [drivers/thermal/thermal_sys.ko] undefined!
> ERROR: "skb_put" [drivers/thermal/thermal_sys.ko] undefined!
> 
> Reported-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/thermal/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20101213.orig/drivers/thermal/Kconfig
> +++ linux-next-20101213/drivers/thermal/Kconfig
> @@ -4,6 +4,7 @@
>  
>  menuconfig THERMAL
>  	tristate "Generic Thermal sysfs driver"
> +	depends on NET
>  	help
>  	  Generic Thermal Sysfs driver offers a generic mechanism for
>  	  thermal management. Usually it's made up of one or more thermal
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
