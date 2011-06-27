Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1F0Oas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:30:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60526 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1F0Oam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:30:42 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Re: [PATCH v6 00/18] MFD/ASoC/Input: TWL4030/TWL60X0 changes
Date: Mon, 27 Jun 2011 17:30:34 +0300
Message-ID: <2519112.D3nfO1VTXY@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110627101835.GI23145@atomide.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <1770658.gTOGV79JgY@barack> <20110627101835.GI23145@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Monday 27 June 2011 12:18:35 Tony Lindgren wrote:
> * Péter Ujfalusi <peter.ujfalusi@ti.com> [110627 02:39]:
> 
> > Hi Tony, Samuel,
> > 
> > Would you have time to take a look at this series?
> 
> 
> Looks good to me. If it conflicts with what we have queued
> in the devel-cleanup branch, I should probably queue it.

There are conflicts in mach-omap2 (quite a lot), if I apply the series on top 
of the devel-cleanup branch.
 
> If there are no conflicts, then Samuel can queue it.

I suppose this should then go through l-o...

-- 
Péter
