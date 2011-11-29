Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1K2Oiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:38:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45435 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755851Ab1K2Oiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:38:46 -0500
Date: Tue, 29 Nov 2011 14:38:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111129143842.GC26800@opensource.wolfsonmicro.com>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
 <4ED37CE3.6040008@metafoo.de>
 <CANKRQnh7MnSQdKXvPJvSPzf-7afXmHip9LqR1cKCgB6HXqcnBg@mail.gmail.com>
 <4ED4EE48.8070100@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED4EE48.8070100@metafoo.de>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 03:38:00PM +0100, Lars-Peter Clausen wrote:

> Also this doesn't make much sense:
> +	{"Input Mux", "Analog MIC in", "MICBIAS"},
> +	{"Input Mux", "Digital MIC in", "MICBIAS"},

> You have mux, but both possible settings of the mux connect to the same
> source, which pretty much makes the mux useless.

Plus the fact that the MICBIAS is unlikely to be directly connected to
either input within the CODEC, it will almost certainly be connected by
circuitry on the board and therefore mapped by the machine driver for
the system.
