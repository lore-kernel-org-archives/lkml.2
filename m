Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2DPPC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:02:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:33203 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab2DPPC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89585027"
Date: Mon, 16 Apr 2012 17:10:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Denis Turischev <denis@compulab.co.il>,
        Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH] mfd: use module_pci_driver
Message-ID: <20120416151035.GE24130@sortiz-mobl>
References: <1333415359.18133.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333415359.18133.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Apr 03, 2012 at 09:09:19AM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/mfd/* to use module_pci_driver()
> macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Andres Salomon <dilinger@queued.net>
> Cc: Ira W. Snyder <iws@ovro.caltech.edu>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: Denis Turischev <denis@compulab.co.il>
> Cc: Harald Welte <HaraldWelte@viatech.com>
> ---
>  drivers/mfd/cs5535-mfd.c          |   13 +------------
>  drivers/mfd/janz-cmodio.c         |   17 +----------------
>  drivers/mfd/lpc_sch.c             |   13 +------------
>  drivers/mfd/rdc321x-southbridge.c |   13 +------------
>  drivers/mfd/vx855.c               |   12 +-----------
>  5 files changed, 5 insertions(+), 63 deletions(-)
Applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
