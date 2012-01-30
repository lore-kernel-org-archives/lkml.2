Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2A3VIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:08:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:12968 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab2A3VIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:08:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="102004630"
Message-ID: <4F2706AE.8020801@linux.intel.com>
Date: Mon, 30 Jan 2012 13:07:58 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] cpufreq/gx: Fix the compile error
References: <20120130144720.5908.37381.stgit@bob.linux.org.uk>
In-Reply-To: <20120130144720.5908.37381.stgit@bob.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2012 6:47 AM, Alan Cox wrote:
> From: Alan Cox<alan@linux.intel.com>
>
> Someone forgot to test this one it seems.

Sorry about that
Thanks. Greg can you please add it to the cpuid probe patchkit?

-Andi

> Signed-off-by: Alan Cox<alan@linux.intel.com>
> ---
>
>   drivers/cpufreq/gx-suspmod.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
> index 5a06c0b..456bee0 100644
> --- a/drivers/cpufreq/gx-suspmod.c
> +++ b/drivers/cpufreq/gx-suspmod.c
> @@ -172,7 +172,7 @@ static struct pci_device_id gx_chipset_tbl[] __initdata = {
>   	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
>   	{ 0, },
>   };
> -MODULE_DEVICE_TABLE(gx_chipset_tbl);
> +MODULE_DEVICE_TABLE(pci, gx_chipset_tbl);
>
>   static void gx_write_byte(int reg, int value)
>   {
>

