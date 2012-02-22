Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2BVHex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:34:53 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:38841 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab2BVHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:34:52 -0500
Message-ID: <4F449A9F.1040907@ti.com>
Date: Wed, 22 Feb 2012 09:34:55 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120215 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/3] MFD: twl6040: Conversion to i2c driver
References: <1328868018-24668-1-git-send-email-peter.ujfalusi@ti.com> <20120220194736.GN5387@sortiz-mobl> <4F4372E3.4050408@ti.com> <20120221110533.GT5387@sortiz-mobl> <1329846755.20666.4.camel@odin> <20120221184427.GQ18185@atomide.com>
In-Reply-To: <20120221184427.GQ18185@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 02/21/2012 08:44 PM, Tony Lindgren wrote:
> Yeah looks OK to me, acked that patch. Let me know if there are
> others I should look.

I would appreciate if you could take a look at this series as well:
TWL6040: Regulator support
http://marc.info/?l=linux-omap&m=132947934522602&w=2

I have separated the twl6040 i2c driver conversion, and regulator
support since they are dealing with different issues.
If you know who should look at the drivers/regulator/twl-regulator.c,
drivers/mfd/twl.c changes could you CC them as well?

Regards,
Péter
