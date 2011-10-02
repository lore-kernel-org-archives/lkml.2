Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1JBSYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:24:44 -0400
Received: from bitmer.com ([213.157.87.50]:51702 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab1JBSYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:24:36 -0400
Date: Sun, 2 Oct 2011 21:24:26 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 21/30] sound/soc/omap: limit to omap2plus
Message-Id: <20111002212426.40a1665618c818fc1f4e001d@bitmer.com>
In-Reply-To: <4511363.OPCpQMvKWi@wuerfel>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
	<1317566760-25681-22-git-send-email-arnd@arndb.de>
	<20111002204035.2e5b98943ed5137fd689b9be@bitmer.com>
	<4511363.OPCpQMvKWi@wuerfel>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Oct 2011 20:03:38 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Sunday 02 October 2011 20:40:35 Jarkko Nikula wrote:
> > Strange. I'm able to build them fine with omap1_defconfig and with two
> > supported OMAP1 ASoC machine drivers we have:
> > 
> > CONFIG_SND_OMAP_SOC_AMS_DELTA=y
> > CONFIG_SND_OMAP_SOC_OSK5912=y
> > 
> > What's the error you are seeing? I guess there might be some missing
> > dependency that doesn't get visible with omap1_defconfig.
> > 
> > I would like to get that fixed instead of disabling OMAP1 ASoC support
> > as the ams-delta in kernel is alive device thanks to active developer
> > Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>.
> 
> I no longer have the original bug, maybe it was a false positive.
> I'll drop this patch and have another look if the problem comes back.
> 
> Thanks for taking a closer look!
> 
Now when I remember we had one build error. Hopefully it was the same
than you observed?

commit e574044acbad7421879270a80acd337459c94cc8
Author: Jarkko Nikula <jarkko.nikula@bitmer.com>
Date:   Thu Aug 18 15:02:47 2011 +0300

    ASoC: omap: Fix build errors in ams-delta
    
    Fix "error: too few arguments to function 'ams_delta_set_bias_level'"
    build errors in ams-delta.c that were introduced after commit d4c6005 ("ASoC
    Add context parameter to card DAPM callbacks") by adding dapm context
    to ams_delta_set_bias_level calls.


-- 
Jarkko
