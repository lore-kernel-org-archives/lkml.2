Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1JMXcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:32:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53220 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1JMXcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:32:52 -0400
Date: Fri, 14 Oct 2011 00:32:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to
 regmap_read
Message-ID: <20111013233250.GA21690@sirena.org.uk>
References: <1318490575.2857.8.camel@phoenix>
 <20111013165129.GO5193@opensource.wolfsonmicro.com>
 <CAF+7xWkVLNgToGiEn+xqgnii7QozNu0QAf2U-kXRNRtVK0dkqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWkVLNgToGiEn+xqgnii7QozNu0QAf2U-kXRNRtVK0dkqA@mail.gmail.com>
X-Cookie: Do not exceed recommended dosage.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 06:39:43AM +0800, Axel Lin wrote:

> +       codec->cache_bypass = 1;
> +       for (i = 0 ; i < codec->driver->reg_cache_size ; i += step) {
> +               snd_soc_read(codec, i);
> +               cache[i] = val;
> +       }
> +       codec->cache_bypass = 0;

Oh, sorry - I misread this and this is what I'm expecting.
