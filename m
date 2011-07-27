Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1G0SyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:54:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:55736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab1G0SyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:54:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="32984487"
Message-ID: <4E305EDC.3030602@linux.intel.com>
Date: Wed, 27 Jul 2011 11:54:20 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] Re: linux-next: Tree for July 27 (misc/pti)
References: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au> <20110727092740.2228dd94.rdunlap@xenotime.net>
In-Reply-To: <20110727092740.2228dd94.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 09:27 AM, Randy Dunlap wrote:
> On Wed, 27 Jul 2011 14:11:51 +1000 Stephen Rothwell wrote:
>
>> Hi all,
>
>
> I am still applying the drivers/misc/ patch below that was posted on July 7.
> Is there a drivers/misc/ maintainer?  Andrew?
>
> Hm, this patch needs to be applied to mainline.
>

This one too:

http://marc.info/?l=linux-next&m=131016084730837&w=2

> ---
> From: J Freyensee<james_p_freyensee@linux.intel.com>
>
> Intel-Atom implementation of PTI will not work with PCI
> configured off, so the pti driver should not be compiled
> in the event someone does not enable PCI in the linux kernel.
>
> Signed-off-by: J Freyensee<james_p_freyensee@linux.intel.com>
> Acked-by: Randy Dunlap<randy.dunlap@oracle.com>
> Acked-by: Stephen Rothwell<sfr@canb.auug.org.au>
> ---
>   drivers/misc/Kconfig |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4e349cd..7fd32a6 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -146,6 +146,7 @@ config PHANTOM
>
>   config INTEL_MID_PTI
>   	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
> +	depends on PCI
>   	default n
>   	help
>   	  The PTI (Parallel Trace Interface) driver directs


-- 
J (James/Jay) Freyensee
Storage Technology Group
Intel Corporation
