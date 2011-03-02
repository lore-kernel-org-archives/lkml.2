Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1CBKKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:10:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:39535 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756534Ab1CBKKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:10:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="396255551"
Date: Wed, 2 Mar 2011 11:10:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/3] mfd: mc13xxx-core: add MODULE_DEVICE_TABLE
Message-ID: <20110302101045.GB16181@sortiz-mobl>
References: <1298874735.5562.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298874735.5562.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Feb 28, 2011 at 02:32:15PM +0800, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> After adding the MODULE_DEVICE_TABLE, below entries will be added to
> modules.alias:
> alias spi:mc13892 mc13xxx_core
> alias spi:mc13783 mc13xxx_core
Thanks, all 3 patches applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
