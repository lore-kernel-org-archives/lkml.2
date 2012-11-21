Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2KUNkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:40:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:14855 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab2KUNkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:40:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="252382310"
Date: Wed, 21 Nov 2012 14:39:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        oakad@yahoo.com, bp@alien8.de
Subject: Re: [PATCH v3 0/2] rtsx patch for for-next branch in MFD tree
Message-ID: <20121121133957.GR18738@sortiz-mobl>
References: <cover.1353381810.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1353381810.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Tue, Nov 20, 2012 at 11:24:29AM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Wei WANG (2):
>   mmc/host/rtsx: Configure SD_CFG2 register in sd_rw_multi
>   mmc/host/rtsx: Explicitely include slab.h in rtsx_pci_sdmmc.c
> 
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    2 ++
>  1 file changed, 2 insertions(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
