Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab0EMSMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:12:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17456 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0EMSMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:12:17 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 13 May 2010 20:12:44 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH -next] usb: fix functionfs for CONFIG_NET disabled
In-reply-to: <20100513094112.86acf7c2.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-id: <op.vcnovimh7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <20100513171540.54b308d0.sfr@canb.auug.org.au>
 <20100513094112.86acf7c2.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 18:41:12 +0200, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Fix functionfs build to handle CONFIG_NET not enabled, to prevent
> these build errors:
>
> ERROR: "netif_carrier_on" [drivers/usb/gadget/g_ffs.ko] undefined!
[...]

> @@ -726,7 +726,7 @@ config USB_FUNCTIONFS
> config USB_FUNCTIONFS_ETH
>  	bool "Include CDC ECM (Ethernet) function"
> -	depends on USB_FUNCTIONFS
> +	depends on USB_FUNCTIONFS && NET
>  	help
>  	  Include an CDC ECM (Ethernet) funcion in the CDC ECM (Funcion)
>  	  Filesystem.  If you also say "y" to the RNDIS query below the
> @@ -734,7 +734,7 @@ config USB_FUNCTIONFS_ETH
> config USB_FUNCTIONFS_RNDIS
>  	bool "Include RNDIS (Ethernet) function"
> -	depends on USB_FUNCTIONFS
> +	depends on USB_FUNCTIONFS && NET
>  	help
>  	  Include an RNDIS (Ethernet) funcion in the Funcion Filesystem.
>  	  If you also say "y" to the CDC ECM query above the gadget will

Looks reasonable.  Thanks!

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
