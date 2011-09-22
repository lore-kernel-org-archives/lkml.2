Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1IVRCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:02:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54163 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1IVRB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:01:59 -0400
Date: Thu, 22 Sep 2011 18:01:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Dilan Lee <dilee@nvidia.com>,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Message-ID: <20110922170154.GD1045@sirena.org.uk>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
X-Cookie: Your code should be more efficient!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 05:15:02PM -0600, Stephen Warren wrote:
> From: Dilan Lee <dilee@nvidia.com>
> 
> We found the register settings of wm8903(an audio codec) can't be modified
> in snd_soc_suspend since I2C bus has been suspended before snd_soc_suspend.
> 
> Pop noise will occur when system resume from LP0 if the register settings of wm8903
> haven't be modified correctly in snd_soc_suspend.
> 
> So, we use the suspend_noirq/resume_noirq callbacks to make sure I2C bus still
> operates while running snd_soc_suspend.
> 
> Signed-off-by: Dilan Lee <dilee@nvidia.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

At Stephen's request

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
