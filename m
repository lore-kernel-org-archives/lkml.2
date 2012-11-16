Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2KPJms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:42:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61952 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPJmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:42:46 -0500
Date: Fri, 16 Nov 2012 01:39:36 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-pm@vger.kernel.org, Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v8 2/3] pwm_backlight: use power sequences
Message-ID: <20121116093936.GA22239@lizard>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <1353047903-14363-3-git-send-email-acourbot@nvidia.com>
 <20121116084958.GB20785@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121116084958.GB20785@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 09:49:58AM +0100, Thierry Reding wrote:
> On Fri, Nov 16, 2012 at 03:38:22PM +0900, Alexandre Courbot wrote:
> > Make use of the power sequences specified in the device tree or platform
> > data to control how the backlight is powered on and off.
> > 
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > Reviewed-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> Anton,
> 
> I would normally take pwm-backlight patches through the PWM tree, but
> since this patch depends on the first in this series, I think it would
> be easier if you took it through your tree along with the rest of the
> series. If that's okay with you:
> 
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

Sure, I'll take it. Thank you!
