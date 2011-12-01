Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1LALLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:11:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44162 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300Ab1LALLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:11:40 -0500
Date: Thu, 1 Dec 2011 11:11:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111201111137.GC2915@opensource.wolfsonmicro.com>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
 <20111128132317.GD8275@opensource.wolfsonmicro.com>
 <CANKRQng3YtYZggVWp3BWyaWyaHAbN1hccJksWELnv2co37rEcQ@mail.gmail.com>
 <20111129122916.GM2851@opensource.wolfsonmicro.com>
 <CANKRQnjpYDJWfJO-G5HsE6es7metHeqgP32R3eo99MaE2zdNpQ@mail.gmail.com>
 <s5hhb1kvix5.wl%tiwai@suse.de>
 <CANKRQniRonz5UcQ-KgnFJptPkqgWWrJsFuW31f8bWCf_xx-tTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQniRonz5UcQ-KgnFJptPkqgWWrJsFuW31f8bWCf_xx-tTA@mail.gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 04:57:52PM +0900, Tomoya MORINAGA wrote:

> You mean "EQ Band1" and "EQ BAND1" are inconsistent names ?
> If yes, can you accept the followings ?

> EQ Band1 Input Volume
> EQ Band1 Switch

"EQ Band1 Input" and "EQ Band1" are still different, they should be the
same.
