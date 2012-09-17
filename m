Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2IQIoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:44:01 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44532 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755105Ab2IQIn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:43:59 -0400
Message-ID: <5056E300.809@ti.com>
Date: Mon, 17 Sep 2012 11:44:48 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, Ricardo Neri <ricardo.neri@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dan Williams <djbw@fb.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [alsa-devel] [PATCH v3 00/15] ASoC: OMAP: Convert to use dmaengine
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com> <1347851866.1943.126.camel@vkoul-udesk3>
In-Reply-To: <1347851866.1943.126.camel@vkoul-udesk3>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 09/17/2012 06:17 AM, Vinod Koul wrote:
> On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
>> Hello,
> 
> dmaengine parts look good to me. How do you want to get this merged,
> dmaengine or ASoC tree?

Thank you, I would prefer it to go via ASoC if it is not a problem. It is
possible to separate the dmaengine core related patches and the patches for
the OMAP drivers but I think it is better to keep them together so we can have
them in a same tree for testing it further.

Regards,
Péter
