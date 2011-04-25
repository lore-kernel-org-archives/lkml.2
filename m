Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1DYPXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:23:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31710 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab1DYPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:23:20 -0400
Date: Mon, 25 Apr 2011 08:22:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH] treewide: Cleanup continuations and remove
 logging message whitespace
Message-Id: <20110425082230.6d656ed0.randy.dunlap@oracle.com>
In-Reply-To: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
References: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DB591BD.0021:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 20:38:19 -0700 Joe Perches wrote:

> Using C line continuation inside format strings is error prone.
> Clean up the unintended whitespace introduced by misuse of \.
> Neaten correctly used line continations as well for consistency.
> 
> drivers/scsi/arcmsr/arcmsr_hba.c has these errors as well,
> but arcmsr needs a lot more work and the driver should likely be
> moved to staging instead.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  arch/arm/plat-mxc/cpufreq.c                     |    4 +-
>  drivers/dma/dmatest.c                           |    4 +-
>  drivers/firmware/iscsi_ibft.c                   |    4 +-
>  drivers/gpio/ab8500-gpio.c                      |    7 ++---
>  drivers/media/video/usbvision/usbvision-video.c |    5 ++-
>  drivers/message/fusion/mptbase.c                |   22 ++++++++----------
>  drivers/misc/bh1780gli.c                        |    8 +++---
>  drivers/misc/spear13xx_pcie_gadget.c            |    4 +-
>  drivers/net/atlx/atl1.c                         |    5 ++-
>  drivers/net/wireless/airo.c                     |   27 ++++++++++++-----------
>  drivers/net/wireless/iwlegacy/iwl-4965-calib.c  |    4 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-calib.c    |    4 +-
>  drivers/regulator/max8998.c                     |    4 +-
>  drivers/tty/serial/bfin_sport_uart.c            |    3 +-
>  drivers/tty/serial/mfd.c                        |    4 +-
>  drivers/usb/host/uhci-hcd.c                     |    7 +++--
>  drivers/usb/storage/ene_ub6250.c                |    4 +-
>  17 files changed, 60 insertions(+), 60 deletions(-)


Joe,
Is there a decent fix for this warning in linux-next:

drivers/tty/n_gsm.c:535: warning: zero-length gnu_printf format string

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
