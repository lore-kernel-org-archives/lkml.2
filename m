Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1K1KjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:39:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:7427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1K1Ki7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:38:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,583,1315206000"; 
   d="scan'208";a="89731684"
Subject: Re: [PATCH 1/3] dmaengine: at_hdmac: add const to struct
 platform_device_id definition
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
In-Reply-To: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
References: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 16:05:54 +0530
Message-ID: <1322476554.1516.980.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 11:55 +0100, Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/at_hdmac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Applied all 3, thanks

-- 
~Vinod

