Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2BGNak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:30:40 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:56287 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942Ab2BGNai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:30:38 -0500
Message-ID: <4F312772.6090000@ti.com>
Date: Tue, 07 Feb 2012 15:30:26 +0200
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
Subject: Re: [PATCH v2 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1
 supplies
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com> <1328619678-26080-8-git-send-email-peter.ujfalusi@ti.com> <20120207131657.GL3332@opensource.wolfsonmicro.com>
In-Reply-To: <20120207131657.GL3332@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 03:16 PM, Mark Brown wrote:
> though I'd be inclined to just embed this structure into the twl6040
> struct directly, you're always going to need to allocate it and it saves
> a tiny bit of error handling and whatnot.

True. I'm not sure why I have settled with this solution... As I recall
I just did not wanted to add the regulator related includes to the
mfd/twl6040.h header.

-- 
Péter
