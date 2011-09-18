Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1IRQe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 12:34:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:17392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab1IRQe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 12:34:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="49645500"
Date: Sun, 18 Sep 2011 18:37:07 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 01/17] MFD: twl6040: Remove global pointer for
 platform_device
Message-ID: <20110918163706.GC7286@sortiz-mobl>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
 <1316090379-30760-2-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316090379-30760-2-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Sep 15, 2011 at 03:39:23PM +0300, Peter Ujfalusi wrote:
> There is no need to keep global pointer for the platform
> device, since it is only used for dev_* prints, and the
> device pointer available within the twl6040 structure.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

