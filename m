Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab1FQNWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:22:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43039 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab1FQNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:22:33 -0400
Date: Fri, 17 Jun 2011 14:22:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v5 14/18] ASoC: twl6040: Support other
	sample rates in constraints.
Message-ID: <20110617132227.GA4951@sirena.org.uk>
References: <1307983070-2257-1-git-send-email-peter.ujfalusi@ti.com> <1307983070-2257-15-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307983070-2257-15-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: A friend in need is a pest indeed.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 07:37:46PM +0300, Peter Ujfalusi wrote:
> From: Liam Girdwood <lrg@ti.com>
> 
> Add other supported sample rates to LP and HP modes.
> 
> Signed-off-by: Liam Girdwood <lrg@ti.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This shouldn't be part of this series as far as I can tell, there's no
textual link with the rest of it?
