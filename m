Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2CDWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:09:59 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46055 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2CDWJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:09:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.torokhov@gmail.com designates 10.68.191.230 as permitted sender) smtp.mail=dmitry.torokhov@gmail.com; dkim=pass header.i=dmitry.torokhov@gmail.com
Date: Sun, 4 Mar 2012 11:05:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] MFD: twl6040: Convert to i2c driver, and separate
 it from twl core
Message-ID: <20120304190534.GA22602@core.coreip.homeip.net>
References: <1330418092-12314-1-git-send-email-peter.ujfalusi@ti.com>
 <1330418092-12314-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330418092-12314-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:34:52AM +0200, Peter Ujfalusi wrote:
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

For input part:

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
