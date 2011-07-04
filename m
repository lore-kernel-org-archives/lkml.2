Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1GDLvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:51:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:23096 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1GDLvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:51:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="22436656"
Date: Mon, 4 Jul 2011 13:51:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tony Lindgren <tony@atomide.com>
Cc: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Re: [PATCH v6 00/18] MFD/ASoC/Input: TWL4030/TWL60X0 changes
Message-ID: <20110704115115.GB3021@sortiz-mobl>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <1770658.gTOGV79JgY@barack>
 <20110627101835.GI23145@atomide.com>
 <2519112.D3nfO1VTXY@barack>
 <20110628061721.GY23145@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110628061721.GY23145@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, Jun 27, 2011 at 11:17:21PM -0700, Tony Lindgren wrote:
> * Péter Ujfalusi <peter.ujfalusi@ti.com> [110627 07:25]:
> > Hi Tony,
> > 
> > On Monday 27 June 2011 12:18:35 Tony Lindgren wrote:
> > > * Péter Ujfalusi <peter.ujfalusi@ti.com> [110627 02:39]:
> > > 
> > > > Hi Tony, Samuel,
> > > > 
> > > > Would you have time to take a look at this series?
> > > 
> > > 
> > > Looks good to me. If it conflicts with what we have queued
> > > in the devel-cleanup branch, I should probably queue it.
> > 
> > There are conflicts in mach-omap2 (quite a lot), if I apply the series on top 
> > of the devel-cleanup branch.
> >
> > > If there are no conflicts, then Samuel can queue it.
> > 
> > I suppose this should then go through l-o...
> 
> OK. Assuming Samuel is fine with the patches, 
I am fine with them. I just had some minor comments about patch #10, but you
can go ahead and add my:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to patches #5,6,7,8 and 10.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
