Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2FTLCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:02:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:25682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab2FTLCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:02:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167950898"
Subject: Re: [PATCH v2 1/3] dmaengine: Add wrapper for device_tx_status
 callback
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1339438302-12417-1-git-send-email-lars@metafoo.de>
References: <1339438302-12417-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 16:24:22 +0530
Message-ID: <1340189662.1927.1648.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 20:11 +0200, Lars-Peter Clausen wrote:
> This patch adds a small inline wrapper for the devivce_tx_status callback of a
> dma device. This makes the source code of users of this function a bit more
> compact and a bit more legible.
Applied, thanks

rest of the series should go thru ASoC tree.

-- 
~Vinod

