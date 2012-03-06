Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab2CFLtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:49:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:30335 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759149Ab2CFLtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:49:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125596627"
Subject: Re: [PATCH v3 2/2] dmaengine: Add support for multiple descriptors
 for imx-dma.
From: Vinod Koul <vinod.koul@intel.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1330676927-7330-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330676927-7330-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 17:24:12 +0530
Message-ID: <1331034852.24656.197.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 09:28 +0100, Javier Martin wrote:
> dmaengine specifies the possibility that several descriptors
> can be queued for transfer. It also indicates that tasklets
> must be used for DMA callbacks.
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
Applied this and 1/2 or previous one

-- 
~Vinod

