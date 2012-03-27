Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2C0SDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:03:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53269 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2C0SDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:03:12 -0400
Date: Tue, 27 Mar 2012 21:02:18 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de, vinod.koul@intel.com
Subject: Re: [PATCH] ASoC: ep93xx-i2s: use devm_* helpers to cleanup probe
Message-ID: <20120327180218.GG5812@mwesterb-mobl.ger.corp.intel.com>
References: <201203261600.17787.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203261600.17787.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 04:00:17PM -0700, H Hartley Sweeten wrote:
> Use the devm_* helpers to cleanup the probe routine. This also eliminates
> having to carry the mem value in the private data for the remove.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>

> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> CC: Takashi Iwai <tiwai@suse.de>
> Cc: Vinod Koul <vinod.koul@intel.com>
