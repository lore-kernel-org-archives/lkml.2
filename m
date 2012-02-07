Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2BGNwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:52:05 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:34757 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875Ab2BGNwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:52:03 -0500
Message-ID: <4F312C80.2020108@ti.com>
Date: Tue, 07 Feb 2012 15:52:00 +0200
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
Subject: Re: [PATCH v2 2/7] MFD: twl6040: Convert to i2c driver, and separate
 it from twl core
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com> <1328619678-26080-3-git-send-email-peter.ujfalusi@ti.com> <20120207132925.GN3332@opensource.wolfsonmicro.com> <4F31298C.5090008@ti.com> <20120207134344.GP3332@opensource.wolfsonmicro.com>
In-Reply-To: <20120207134344.GP3332@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 03:43 PM, Mark Brown wrote:
> That just sounds far too icky - I'm really not happy that people have
> been doing that in ASoC TBH, it just makes everything more tricky than
> it should be.  It save a little bit of effort with the control but just
> pushes that complexity elsewhere where you're not expecting it.

Fair enough. I'll find a way to do this properly.

Thanks,
Péter
