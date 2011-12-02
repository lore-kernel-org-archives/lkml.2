Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1LBBGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:06:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42294 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746Ab1LBBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:06:52 -0500
Date: Fri, 2 Dec 2011 01:06:47 +0000
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
Message-ID: <20111202010644.GC31948@opensource.wolfsonmicro.com>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
 <20111128132317.GD8275@opensource.wolfsonmicro.com>
 <CANKRQng3YtYZggVWp3BWyaWyaHAbN1hccJksWELnv2co37rEcQ@mail.gmail.com>
 <20111129122916.GM2851@opensource.wolfsonmicro.com>
 <CANKRQnjpYDJWfJO-G5HsE6es7metHeqgP32R3eo99MaE2zdNpQ@mail.gmail.com>
 <s5hhb1kvix5.wl%tiwai@suse.de>
 <CANKRQniRonz5UcQ-KgnFJptPkqgWWrJsFuW31f8bWCf_xx-tTA@mail.gmail.com>
 <20111201111137.GC2915@opensource.wolfsonmicro.com>
 <CANKRQng4+fKY-3FLMKB_Z-JLB-Xhqpvx90uecFNQCS=NDG55pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQng4+fKY-3FLMKB_Z-JLB-Xhqpvx90uecFNQCS=NDG55pw@mail.gmail.com>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 09:33:23AM +0900, Tomoya MORINAGA wrote:

> Which description do you want ?

> EQ Band1 Volume
> EQ Band1 Switch

> or

> EQ Band1 Input Volume
> EQ Band1 Input Switch

Either is fine, if I had to pick one I'd go with the first one.  The
important thing is that Switch and Volume use the same string.
