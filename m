Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2BIHrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:47:21 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:40458 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362Ab2BIHrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:47:20 -0500
Message-ID: <4F337A0A.1010101@ti.com>
Date: Thu, 09 Feb 2012 09:47:22 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120208 Thunderbird/10.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
CC: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] MFD: twl6040: Conversion to i2c driver
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/07/2012 03:01 PM, Peter Ujfalusi wrote:
> Still in the to-do list:
> Implement proper regulator support on SDP4430, and PandaBoard for the needed
> supplies by the twl6040.
> The supply source is the same on both boards:
> TWL6040 VDD2V1 <- TWL6030 V2V1 SMPS
> TWL6040 VDDVIO <- TWL6030 V1V8 SMPS
> 
> There seams to be no control implemented in the regulator driver for these SMPS
> regulators, so this need to be done first.
> 
> The reason that I'm sending this series (even when I know that the proper
> regulator support is missing for SDP4430/PandaBoard) is to get feedback for the
> rest of the series, so I can include the fixes in the v3 series.

I will separate the i2c driver conversion, and the regulator support to
avoid bloating this series.
Could you review the first three patch from this series (the i2c driver
conversion part)?
I can as well resend only that as version v3, but I would like to apply
the fixes for the issues you might find before I send it.

Thank you,
Péter
