Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1GFJHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:07:43 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59429 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab1GFJHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:07:42 -0400
Date: Wed, 6 Jul 2011 02:06:38 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
Message-ID: <20110706090638.GA29266@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 01:09:39AM -0700, Ram Pai wrote:
> Multiple attempts to dynamically reallocate pci resources have unfortunately
> lead to regressions. Though we continue to fix the regressions and fine tune the
> dynamic-reallocation behavior, we have not reached a acceptable state yet.
> 
> This patch provides a interim solution. It disables dynamic-reallocation; by
> default, with the ability to enable it through pci=realloc kernel command line
> parameter.

> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  Documentation/kernel-parameters.txt |    2 ++
>  arch/x86/pci/common.c               |    4 ++++
>  drivers/pci/setup-bus.c             |    7 +++++++
>  include/linux/pci.h                 |    2 ++
>  4 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index fd248a3..aa47be7 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2015,6 +2015,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  				the default.
>  				off: Turn ECRC off
>  				on: Turn ECRC on.
> +		realloc		reallocate PCI resources if allocations done by BIOS
> +				are erroneous.
> 
>  	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
>  			Management.

Linus/Jesse,

	Are we merging this patch in 3.0.0 ?

RP
