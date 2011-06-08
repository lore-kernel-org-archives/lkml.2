Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1FHGvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:51:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58789 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1FHGvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:51:17 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 03/12] OMAP3: Move common pmic configuration to pmic-common
Date: Wed, 8 Jun 2011 09:51:30 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo; KDE/4.6.3; x86_64; ; )
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
References: <1307456297-15010-1-git-send-email-peter.ujfalusi@ti.com> <1307456297-15010-4-git-send-email-peter.ujfalusi@ti.com> <20110607144534.GA27477@atomide.com>
In-Reply-To: <20110607144534.GA27477@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201106080951.31056.peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 June 2011 17:45:35 Tony Lindgren wrote:
> > +#define TWL_COMMON_PDATA_BCI		(1 << 1)
> > +#define TWL_COMMON_PDATA_MADC		(1 << 2)
> > +#define TWL_COMMON_PDATA_CODEC		(1 << 3)
> 
> This is looking good, thanks for cleaning up the twl bloat in
> board-*.c files :)

As I recall the first three patch results ~600 less lines of code under mach-
omap2.

> Maybe already define TWL_COMMON_PDATA_AUDIO here so you can
> drop most of patch 7/12?
> 
> If you need both then you can temporarily have:
> 
> #define TWL_COMMON_PDATA_CODEC	TWL_COMMON_PDATA_AUDIO

I have not thought about this.
But I think we can live with the TWL_COMMON_PDATA_AUDIO all the way.
I'll wait for more comments, and I'll do this for the v3.

Thanks,
Péter
