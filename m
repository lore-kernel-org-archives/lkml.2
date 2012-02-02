Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2BBNEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:04:04 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60966 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589Ab2BBNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:04:01 -0500
Message-ID: <4F2A89BC.6090303@ti.com>
Date: Thu, 02 Feb 2012 15:03:56 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120106 Thunderbird/9.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 5/7] OMAP: sdp4430: Add fixed regulator for twl6040 needs
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com> <1328185019-29575-6-git-send-email-peter.ujfalusi@ti.com> <20120202124025.GF7428@opensource.wolfsonmicro.com>
In-Reply-To: <20120202124025.GF7428@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 02:40 PM, Mark Brown wrote:
> On Thu, Feb 02, 2012 at 02:16:57PM +0200, Peter Ujfalusi wrote:
>> The twl6040 VIO power is connected to SMPS V1V8, the
>> V2V1 power is coming from SMPS V2V1 of twl6030.
>> These are fixed, always on regulators.
>> Create fixed voltage regulators for these supplies.
> 
> Shouldn't the PMIC be creating the relevant fixed voltage regulators?
> It's a bit clearer given that the supplies actually come from the PMIC
> and it would cut down a bit on the boilerplate in boards (though much
> less so with device tree, sadly).

Yes these are coming from twl6030, so it might be better to create the
fixed regulators in the PMIC driver. I'll take a look.

Thanks,
Péter
