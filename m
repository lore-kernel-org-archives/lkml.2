Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1LIKeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:34:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:31998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab1LIKeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:34:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84654664"
Message-ID: <4EE1E425.5090402@intel.com>
Date: Fri, 09 Dec 2011 12:34:13 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/4] mmc: sdhci/sdhci-pci: prepare for wl12xx/SDIO
References: <1320217041-2580-1-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1320217041-2580-1-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/11 08:57, Adrian Hunter wrote:
> Hi
> 
> Here are some changes (V2) to allow wl12xx/SDIO to be set up for sdhci-pci.
> There a a couple of fixes plus a method to get platform data.  The
> changes to the platform files are not included in this patchset.
> 
> 
> V2: change sdhci_pci_get_data() from a weak function to a function
> pointer
> 
> 
> Adrian Hunter (4):
>       mmc: sdhci: fix vmmc handling
>       mmc: sdhci: prevent card detection activity for non-removable cards
>       mmc: sdhci-pci: add platform data
>       mmc: sdhci-pci: get gpio numbers from platform data
> 
>  drivers/Makefile                   |    2 +-
>  drivers/mmc/Makefile               |    3 +-
>  drivers/mmc/host/Makefile          |    1 +
>  drivers/mmc/host/sdhci-pci-data.c  |    5 ++
>  drivers/mmc/host/sdhci-pci.c       |  137 +++++++++++++++++-------------------
>  drivers/mmc/host/sdhci.c           |   50 ++++++-------
>  include/linux/mmc/sdhci-pci-data.h |   18 +++++
>  7 files changed, 116 insertions(+), 100 deletions(-)
>  create mode 100644 drivers/mmc/host/sdhci-pci-data.c
>  create mode 100644 include/linux/mmc/sdhci-pci-data.h

Any comments?  Chris?
