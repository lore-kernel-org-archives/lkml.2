Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2IQIkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:40:37 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:58413 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067Ab2IQIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:40:35 -0400
Message-ID: <5056E233.6010900@ti.com>
Date: Mon, 17 Sep 2012 11:41:23 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 02/15] dmaengine: omap: Add support for pause/resume
 in cyclic dma mode
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>  <1347624358-25582-3-git-send-email-peter.ujfalusi@ti.com> <1347851637.1943.125.camel@vkoul-udesk3>
In-Reply-To: <1347851637.1943.125.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 09/17/2012 06:13 AM, Vinod Koul wrote:
> On Fri, 2012-09-14 at 15:05 +0300, Peter Ujfalusi wrote:
>> -       /* FIXME: not supported by platform private API */
>> -       return -EINVAL;
>> +       /* Pause/Resume only allowed with cyclic mode */
>> +       if (!c->cyclic)
>> +               return -EINVAL; 
> This is not a dma restriction right?

The pause/resume operation has been only used by audio. This might work with
non cyclic modes as well but it has never been used/tested so to be safe I
have added this restriction.

-- 
Péter
