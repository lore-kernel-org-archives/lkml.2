Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2IMIMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:12:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39161 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab2IMILu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:11:50 -0400
Date: Thu, 13 Sep 2012 16:11:43 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH 00/11] ASoC: OMAP: Convert to use dmaengine
Message-ID: <20120913081141.GD20959@opensource.wolfsonmicro.com>
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:46:56PM +0300, Peter Ujfalusi wrote:
> Hello,
> 
> This series will switch the OMAP audio to use dmaengine.
> The final patch which does the switch was based on Russell King's earlier patch.

I'm fine with this from the ASoC side but it sounds like you're going to
respin anyway.  Are the earlier bits of the series safe to apply without
the last bit, it seems like that's the only bit that really needs a
respin so we may as well go ahead and apply the earlier bits now?
