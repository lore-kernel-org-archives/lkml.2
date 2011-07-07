Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1GGJtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:49:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:36697 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1GGJtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,492,1304319600"; 
   d="scan'208";a="27351427"
Date: Thu, 7 Jul 2011 11:49:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 1/5] MFD: twl6040: Use resource to provide irq number
 for slaves
Message-ID: <20110707094936.GR3021@sortiz-mobl>
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
 <1309895376-17446-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309895376-17446-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Jul 05, 2011 at 10:49:32PM +0300, Peter Ujfalusi wrote:
> Provide the irq number for slaves via resource on the
> platform device.
> The irq number configuration is done in the twl6040-core
> at probe time, so machine drivers do not need to be
> modified.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
