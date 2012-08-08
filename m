Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab2HHObX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:31:23 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58632 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab2HHObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:31:21 -0400
Message-ID: <50227837.10400@ti.com>
Date: Wed, 08 Aug 2012 17:31:19 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com> <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com> <20120808131356.GS16861@opensource.wolfsonmicro.com> <50226CF4.1010202@ti.com> <20120808135253.GC16861@opensource.wolfsonmicro.com> <502274DA.9020204@ti.com> <20120808141849.GA24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120808141849.GA24328@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 05:18 PM, Mark Brown wrote:
> I'm struggling to see any reason not to just hold the external mute on
> for the entire time the headset is powered off?

I think because it would mean in most cases that we keep a GPIO line enabled
during the time the HS is not in use, which burns power.
In most cases the mute is enabled when the GPIO line is up.

>> If you are OK with the hassle I can add a patch to the series for
>> include/linux/of.h to handle this.
> 
> Yes, please.

I'll wait for more comments and I'll include it to v2.

-- 
Péter
