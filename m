Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab2HWD5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:57:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:57674 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281Ab2HWD5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:57:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,298,1344236400"; 
   d="scan'208";a="212720314"
Subject: Re: [PATCH v2 3/3] spi: spi-davinci: convert to DMA engine API
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Matt Porter <mporter@ti.com>
Cc: cjb@laptop.org, grant.likely@secretlab.ca,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20120822160417.GA27758@beef>
References: <1345574589-24757-1-git-send-email-mporter@ti.com>
	 <1345574589-24757-4-git-send-email-mporter@ti.com>
	 <1345607122.1895.44.camel@vkoul-udesk3>  <20120822160417.GA27758@beef>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Aug 2012 09:29:40 +0530
Message-ID: <1345694380.1895.87.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 12:04 -0400, Matt Porter wrote:
> for querying of these types of limitations. Right now, the
> mmc driver implicitly knows that EDMA needs this restriction
> but it's something that should be queried before calling
> prep_slave().
that's something we need to add; exporting channel capabilities. We only
tell that it slave or memcpy today, but we need to tell clients what are
channel supported parameter ranges.

-- 
~Vinod

