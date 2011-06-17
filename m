Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1FQN3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:29:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57483 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1FQN3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:29:10 -0400
Date: Fri, 17 Jun 2011 14:29:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Axel Castaneda Gonzalez <x0055901@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v5 17/18] ASoC: twl6040: Configure ramp
	step based on platform
Message-ID: <20110617132906.GD4951@sirena.org.uk>
References: <1307983070-2257-1-git-send-email-peter.ujfalusi@ti.com> <1307983070-2257-18-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307983070-2257-18-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: A friend in need is a pest indeed.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 07:37:49PM +0300, Peter Ujfalusi wrote:
> From: Axel Castaneda Gonzalez <x0055901@ti.com>
> 
> Enable ramp down/up step to be configured based on
> platform.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
