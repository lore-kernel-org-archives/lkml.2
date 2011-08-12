Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1HLCuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:50:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43984 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753396Ab1HLCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:50:05 -0400
Subject: Re: [alsa-devel] [PATCH 1/4] ASoC: DAPM: Allow multiple mixer
 sources to be routed via the same switch
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Frysinger <vapier.adi@gmail.com>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E43A808.4050105@metafoo.de>
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>
	 <20110811093140.GB18454@opensource.wolfsonmicro.com>
	 <4E43A808.4050105@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Fri, 12 Aug 2011 10:22:01 +0900
Message-ID: <1313112121.19990.33.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 11:59 +0200, Lars-Peter Clausen wrote:


> The dapm_is_shared_control() stuff is about sharing kcontrols between multiple
> muxes. This is about sharing the same kcontrol between multiple paths of the
> same mixer.

> i.e

> { "Mono Mixer", "DAC", "Left DAC" },
> { "Mono Mixer", "DAC", "Right DAC" },

> doesn't work without this patch.

OK, makes sense.

