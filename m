Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2ISIdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:33:31 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:56377 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab2ISId1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:33:27 -0400
Message-ID: <50598389.6020600@ti.com>
Date: Wed, 19 Sep 2012 11:34:17 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Tero Kristo <t-kristo@ti.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/14] MFD/ASoC/Input: twl4030-audio submodule DT support
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com> <20120919002439.GB3647@sortiz-mobl>
In-Reply-To: <20120919002439.GB3647@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 09/19/2012 03:24 AM, Samuel Ortiz wrote:
> Hi Peter,
> 
> On Mon, Sep 10, 2012 at 01:46:18PM +0300, Peter Ujfalusi wrote:
>> Hello,
>>
>> Generated on top of:
>> git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git topic/omap
> I applied the first 8 patches, but I'd like to get Mark's ACK for the rest of
> the serie.
> Unless you're expecting Mark to take the whole thing, in which case you can
> add my:
> 
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> to the MFD patches.
> Please let me know how you'd like to proceed.

If Mark is still OK with it I think it would be better to queue this series
via ASoC so we can keep them in one place (also I think patch 14 needs patch 6
in order to not break x86/x86_64 allmodconfig).
On the other hand if they go separately (1-8 via MFD, 9-14 via ASoC) they will
meet in linux-next where this matters the most.

Thank you,
Péter
