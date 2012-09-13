Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2IMJUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:20:09 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:55725 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab2IMJT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:19:57 -0400
Message-ID: <5051A55F.9070902@ti.com>
Date: Thu, 13 Sep 2012 12:20:31 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH 00/11] ASoC: OMAP: Convert to use dmaengine
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com> <20120913081141.GD20959@opensource.wolfsonmicro.com>
In-Reply-To: <20120913081141.GD20959@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 11:11 AM, Mark Brown wrote:
> On Wed, Sep 12, 2012 at 02:46:56PM +0300, Peter Ujfalusi wrote:
>> Hello,
>>
>> This series will switch the OMAP audio to use dmaengine.
>> The final patch which does the switch was based on Russell King's earlier patch.
> 
> I'm fine with this from the ASoC side but it sounds like you're going to
> respin anyway.  Are the earlier bits of the series safe to apply without
> the last bit, it seems like that's the only bit that really needs a
> respin so we may as well go ahead and apply the earlier bits now?

Yes, I'm preparing the second series (adding the pause/resume support).
Patch 2-10 is to prepare the OMAP audio drivers for the dmaengine conversion
they can be applied earlier IMHO.
I can in turn can send only dmaengine related patches in v2 (patch 1 and 10
from this series and additional ones).
Anyways I need some time to figure out how to add back the support for
SNDRV_PCM_INFO_NO_PERIOD_WAKEUP.
Either way is good for me.

-- 
Péter
