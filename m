Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2ITD04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 23:26:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39347 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2ITD0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 23:26:54 -0400
Message-ID: <505A8CEB.6010100@ti.com>
Date: Thu, 20 Sep 2012 05:26:35 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <tony@atomide.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] ARM: dts: Add subnode for ocp2scp
References: <1348050772-27819-1-git-send-email-kishon@ti.com>
In-Reply-To: <1348050772-27819-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 09/19/2012 12:32 PM, Kishon Vijay Abraham I wrote:
> This patch series contains a patch to explicitly add reg property
> to the ocp2scp dt node and a patch to add the subnode for ocp2scp
> (omap-usb2).
> 
> Since the original patch series that adds ocp2scp driver and ocp2scp
> data are merged in arm-soc, I'm sending this patch series based on the
> same tree.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
> 
> But Benoit already pointed out that there's going to be merge conflicts
> as he has sent a bunch of dt data patches to linux-omap (devel-dt) tree.
> So now I'm not sure how that can be actually avoided.

What would you suggest?

I merged arm-soc/drivers/ocp2scp into my dts branch to get a proper base
for that series, but as expected, it conflicts :-(

So I fixed that and pulled this series on top of it.

It is something acceptable for a pull request? We already did that in
the past, but at that time it was not conflicting.

Thanks,
Benoit

