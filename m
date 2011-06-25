Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1FYWmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:42:42 -0400
Received: from void.printf.net ([89.145.121.20]:46877 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1FYWmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:42:40 -0400
From: Chris Ball <cjb@laptop.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 18/35] drivers/mmc changes for SMBIOS and System Firmware
References: <20110623172401.27701.81021.sendpatchset@prarit.bos.redhat.com>
Date: Sat, 25 Jun 2011 18:42:33 -0400
In-Reply-To: <20110623172401.27701.81021.sendpatchset@prarit.bos.redhat.com>
	(Prarit Bhargava's message of "Thu, 23 Jun 2011 13:24:02 -0400")
Message-ID: <m2ei2hfs86.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prarit,

On Thu, Jun 23 2011, Prarit Bhargava wrote:
> drivers/mmc changes for SMBIOS and System Firmware
>
> As part of the new SMBIOS and System Firmware code:
>
> - cleanup of includes for dmi.h and mod_devicetable.h which were included in
> some files that did not need them
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> ---
>  drivers/mmc/host/sdhci-pltfm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
> index dbab040..6fd7336 100644
> --- a/drivers/mmc/host/sdhci-pltfm.c
> +++ b/drivers/mmc/host/sdhci-pltfm.c
> @@ -24,7 +24,6 @@
>  
>  #include <linux/delay.h>
>  #include <linux/highmem.h>
> -#include <linux/mod_devicetable.h>
>  #include <linux/platform_device.h>
>  
>  #include <linux/mmc/host.h>

This patch doesn't apply to mmc-next, and is unnecessary there after
Shawn Guo's cleanup -- there's no mod_devicetable.h include anymore.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
