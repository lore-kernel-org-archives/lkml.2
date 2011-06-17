Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab1FQN2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:28:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55030 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947Ab1FQN2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:28:04 -0400
Date: Fri, 17 Jun 2011 14:27:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v5 15/18] ASoC: twl6040: Remove pll and
	headset mode dependency
Message-ID: <20110617132759.GB4951@sirena.org.uk>
References: <1307983070-2257-1-git-send-email-peter.ujfalusi@ti.com> <1307983070-2257-16-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307983070-2257-16-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: A friend in need is a pest indeed.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 07:37:47PM +0300, Peter Ujfalusi wrote:
> From: Misael Lopez Cruz <misael.lopez@ti.com>
> 
> Remove dependency between pll (hppll, lppll) and headset power
> mode (low-power, high-performance), as headset power mode can
> be used with any pll.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but...

> A new control is created to allow headset power mode configuration
> from userspace. Changing headset power mode during earpiece related
> usecases is not allowed as earpiece requires HS DAC in HP mode.

Might be nicer to allow the user to set the control given that you'll
just ignore the configured value anyway if it's not usable right now.
