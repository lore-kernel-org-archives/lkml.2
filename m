Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1LIMZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:25:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60963 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab1LIMZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:25:07 -0500
Date: Fri, 9 Dec 2011 20:24:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/lapis: add machine driver v3 updated
Message-ID: <20111209122457.GA29492@opensource.wolfsonmicro.com>
References: <1323428632-29309-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323428632-29309-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 08:03:52PM +0900, Tomoya MORINAGA wrote:

> +	snd_soc_dapm_new_controls(dapm, ml7213_dapm_widgets,
> +				  ARRAY_SIZE(ml7213_dapm_widgets));
> +
> +	snd_soc_dapm_add_routes(dapm, ml7213_routes, ARRAY_SIZE(ml7213_routes));

You should also use table based init for these (see the card struct).
Otherwise this looks good, though obviously there's a dependency on the
CPU drivers.
