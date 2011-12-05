Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1LEDF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:05:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:40814 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab1LEDFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:05:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,296,1320652800"; 
   d="scan'208";a="98558456"
Subject: Re: [PATCH] dmaengine: convert drivers/dma/* to use
 module_platform_driver()
From: Vinod Koul <vinod.koul@intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Piotr Ziecik <kosmo@semihalf.com>, Rongjun Ying <rongjun.ying@csr.com>,
        Barry Song <21cnbao@gmail.com>, Pelagicore AB <info@pelagicore.com>
In-Reply-To: <1322291472.20464.3.camel@phoenix>
References: <1322291472.20464.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 08:33:38 +0530
Message-ID: <1323054218.30390.52.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-26 at 15:11 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/dma/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Piotr Ziecik <kosmo@semihalf.com>
> Cc: Rongjun Ying <rongjun.ying@csr.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Pelagicore AB <info@pelagicore.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Applied, Thanks


-- 
~Vinod

