Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1AFAvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:51:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:54758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab1AFAvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:51:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="590293894"
Date: Thu, 6 Jan 2011 00:27:16 +0000
From: Alan Cox <alan@linux.intel.com>
To: Russ Gorby <russ.gorby@intel.com>
Cc: <gregkh@suse.de>, <segoon@openwall.com>, <richardx.r.gorby@intel.com>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 4/7] serial: ifx6x60: set SPI max_speed_hz based on
 platform type
Message-ID: <20110106002716.06a396c7@bob.linux.org.uk>
In-Reply-To: <1294272313-15899-5-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
	<1294272313-15899-5-git-send-email-russ.gorby@intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (ifx_dev->is_6160)
> +		spi->max_speed_hz = 12500000;
> +	else
> +		spi->max_speed_hz = 25000000;

This should be coming directly from the platform data, ditto I suspect
wiring the DMA to is_6160 should probably be a platform "use_dma"
field ?

