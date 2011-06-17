Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab1FQOKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:10:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44084 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab1FQOKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:10:18 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Re: [alsa-devel] [PATCH v5 14/18] ASoC: twl6040: Support other sample rates in constraints.
Date: Fri, 17 Jun 2011 16:09:47 +0300
Message-ID: <1415474.GAIs6zDgU1@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110617132227.GA4951@sirena.org.uk>
References: <1307983070-2257-1-git-send-email-peter.ujfalusi@ti.com> <1307983070-2257-15-git-send-email-peter.ujfalusi@ti.com> <20110617132227.GA4951@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 June 2011 15:22:27 Mark Brown wrote:
> On Mon, Jun 13, 2011 at 07:37:46PM +0300, Peter Ujfalusi wrote:
> > From: Liam Girdwood <lrg@ti.com>
> > 
> > Add other supported sample rates to LP and HP modes.
> > 
> > Signed-off-by: Liam Girdwood <lrg@ti.com>
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> This shouldn't be part of this series as far as I can tell, there's no
> textual link with the rest of it?

I just did not wanted this patch to be buried within another patch.
This patch fixes (completes) the supported sample rates for different power 
modes. I can remove it from the series and send it separately, but I would 
prefer if it is handled together with the rest of the changes.

-- 
Péter
