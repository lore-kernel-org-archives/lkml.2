Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1IRQii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 12:38:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:22196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab1IRQih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 12:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="49645949"
Date: Sun, 18 Sep 2011 18:41:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH 00/17] ASoC: twl6040: Cleanups and fixes
Message-ID: <20110918164118.GM32263@sortiz-mobl>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
 <1316164789.3229.4.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316164789.3229.4.camel@odin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Fri, Sep 16, 2011 at 10:19:49AM +0100, Liam Girdwood wrote:
> On Thu, 2011-09-15 at 15:39 +0300, Peter Ujfalusi wrote:
> > Hello,
> > 
> > The first four patch of this series (the MFD/Input patches) has been already
> > sent to upstream to the relevant lists, but I wanted to include here as well,
> > since I have dependency on that series later on.
> > If it is OK with you, it would be best to merge these MFD/Input changes through
> > the audio tree for 3.2.
> > 
> > Code cleanup, and fixes for the twl6040 codec driver.
> > Main changes:
> > - reg_cache has been rested to chip defaults
> > - codec initialization changes
> > - Correction for the Earphone path
> > - AUX L/R output support
> > - Headset/Handsfree control name changes
> > - Headset DC offset workaround
> > 
> 
> All Acked-by: Liam Girdwood <lrg@ti.com>
> 
> Samuel, IIRC we have a dependency on MFD. Do you mind if this goes via
> ASoC ?
Sure, no problem. I ACKed the MFD parts, if you need it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
