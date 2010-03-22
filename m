Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0CVM70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:59:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55232 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab0CVM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:59:24 -0400
Date: Mon, 22 Mar 2010 08:59:19 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [Patch] netconsole: do not depend on experimental
Message-ID: <20100322125919.GB4288@hmsreliant.think-freely.org>
References: <20100322100305.5518.29500.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322100305.5518.29500.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 05:59:23AM -0400, Amerigo Wang wrote:
> 
> Nowadays, most distributions enable netconsole by default,
> including RHEL, Fedora, Debian, Arch, Opensuse. And
> we don't have any bug reports about it. So I think there
> is no need to mark it as experimental any more.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 0ba5b8e..e3d6c52 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -3252,15 +3252,14 @@ config NET_FC
>  	  "SCSI generic support".
>  
>  config NETCONSOLE
> -	tristate "Network console logging support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Network console logging support"
>  	---help---
>  	If you want to log kernel messages over the network, enable this.
>  	See <file:Documentation/networking/netconsole.txt> for details.
>  
>  config NETCONSOLE_DYNAMIC
> -	bool "Dynamic reconfiguration of logging targets (EXPERIMENTAL)"
> -	depends on NETCONSOLE && SYSFS && EXPERIMENTAL
> +	bool "Dynamic reconfiguration of logging targets"
> +	depends on NETCONSOLE && SYSFS
>  	select CONFIGFS_FS
>  	help
>  	  This option enables the ability to dynamically reconfigure target
> --

Seems reasonable.  Netconsole seems pretty mature.

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
