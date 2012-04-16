Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2DPOiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:38:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:9890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab2DPOh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89575851"
Date: Mon, 16 Apr 2012 16:46:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH for 3.4] MFD: twl6040: Convert to i2c driver, and
 separate it from twl core
Message-ID: <20120416144623.GD24130@sortiz-mobl>
References: <1333443411-23056-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333443411-23056-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Apr 03, 2012 at 11:56:51AM +0300, Peter Ujfalusi wrote:
> Complete the separation of the twl6040 from the twl core since
> it is a separate chip, not part of the twl6030 PMIC.
> 
> Make the needed Kconfig changes for the depending drivers at the same time to
> avoid breaking the kernel build (vibra, ASoC components).
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonicro.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> Acked-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
> Hi Samuel, Tony, Liam,
> 
> Due to some cross tree issues 3.4-rc1 have big regression in OMAP4 audio:
> The twl6040 mfd driver (and codec, vibra) is no longer probe since the twl-core
> now did not create the platform device for it. This means we do not have audio
> working in rc1.
> This patch meant to follow the twl-core change (to not probe the twll6040 as
> platform device), but there were some glitch in the logistics so this patch is
> not in 3.4-rc1.
> 
> I have forward ported it on top of 3.4-rc1, and you can also find the patch in:
> git@gitorious.org:omap-audio/linux-audio.git peter/upstream/for-3.4-rc2
> 
> Can someone take this patch further to be included in 3.4-rc2?
Applied to my for-linus branch. I'll send a pull request this week, so I
expect it to make it to rc4.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
