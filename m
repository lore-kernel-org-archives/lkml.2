Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1K2Mug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:50:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51108 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992Ab1K2Muc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:50:32 -0500
Date: Tue, 29 Nov 2011 12:50:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v4] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111129125029.GN2851@opensource.wolfsonmicro.com>
References: <1322569736-16782-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322569736-16782-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:28:56PM +0900, Tomoya MORINAGA wrote:
> ML26124-01HB/ML26124-02GD is 16bit monaural audio CODEC which has high
> resistance to voltage noise. On chip regulator realizes power supply rejection
> ratio be over 90dB so more than 50dB is improved than ever. ML26124-01HB/

Given the questions you just asked myself and Lars-Peter it seems fairly
clear that the review comments from the previous version so I'm not
going to review this, please resend once the review comments have been
addressed.  Lars-Peter concern seemed especially serious, I'd expect
large sections of the audio functionality to not work without being
connected to the DAPM map.

In general if resubmitting code that has outstanding review issues you
should highlight the known issues and explain why you are resending;
usually if there's an active discussion in progress it's better to wait
for that to die down.
