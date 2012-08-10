Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab2HJT6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:58:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47356 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994Ab2HJT6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:58:08 -0400
Message-ID: <50256797.3020505@ti.com>
Date: Sat, 11 Aug 2012 01:27:11 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>, <a.zummo@towertech.it>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <khilman@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <rtc-linux@googlegroups.com>
Subject: Re: [PATCH v3 0/6] omap-am33xx rtc dt support
References: <cover.1343383616.git.afzal@ti.com>
In-Reply-To: <cover.1343383616.git.afzal@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/2012 5:53 PM, Afzal Mohammed wrote:
> Hi,
> 
> This series makes rtc-omap driver DT capable, adds AM33xx
> RTC DT support along with a few enchancments to the driver.
> 
> rtc-omap driver is made intelligent enough to handle kicker
> mechanism. This helps in removing kicker mechanism support
> done for DaVinci at platform level.
> 
> This has been tested on Beaglebone (AM33xx platform) and on
> DaVinci DA850 EVM.
> 
> This series is based over linux-omap master and can be
> directly applied over linux-next, except for
> [PATCH 6/6] arm/dts: am33xx rtc node.
> 
> PATCH 6/6 should go through linux-omap tree and needs
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg71644.html
> (arm/dts: am33xx wdt node) to get applied cleanly

I tested patches 1-5 on AM18x EVM using rtcwake and hwclock commands.
Also tested on DT enabled AM18x EVM using hwclock.

For patched 1-5:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Alessandro,

I assume you would want me to queue 2/6 through DaVinci tree. That patch
depends on 1/6 being accepted and merged by you. Let me know how you
want to move forward here.

Thanks,
Sekhar
