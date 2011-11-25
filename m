Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1KYLCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 06:02:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37032 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1KYLCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 06:02:45 -0500
Date: Fri, 25 Nov 2011 11:02:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111125110241.GA5315@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <20111121112607.GB3784@opensource.wolfsonmicro.com>
 <CANKRQngsHv5M1+LaDq-fmaFCpG3f80DbJOrtvNShLn6hNWfg=w@mail.gmail.com>
 <20111122111920.GB30048@opensource.wolfsonmicro.com>
 <CANKRQng9zQkWPy8fH39BTQ9PKMEt2bOhEvrn9fWszhqSBO1rjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQng9zQkWPy8fH39BTQ9PKMEt2bOhEvrn9fWszhqSBO1rjw@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 11:03:17AM +0900, Tomoya MORINAGA wrote:

> > drivers/base/regmap and also grep in sound/soc/codecs/*.c

> Though grepping "regmap" at sound/soc/codecs/*.c, I couldn't find any file.
> Is this true ?

You should always submit new code against the current development
version of the subsystem you're submitting against.
