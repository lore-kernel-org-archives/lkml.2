Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1LBMtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:49:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41373 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756087Ab1LBMte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:49:34 -0500
Date: Fri, 2 Dec 2011 12:49:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] sound/soc/lapis: add machine driver
Message-ID: <20111202124931.GN8245@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <1321848532-8784-2-git-send-email-tomoya.rohm@gmail.com>
 <20111121113433.GD3784@opensource.wolfsonmicro.com>
 <CANKRQnjdS1NvcGLa=S1M0D4U_NV3+JR1E4YfAV7Ziq-fE2LQgg@mail.gmail.com>
 <20111202114638.GI8245@opensource.wolfsonmicro.com>
 <CANKRQng5OzqjiQ81OUH+2Aet8DAM198s6B=_1FuASnd19BU26w@mail.gmail.com>
 <20111202122205.GL8245@opensource.wolfsonmicro.com>
 <CANKRQnhcA-bzcMnR2BBPStb7XgZp2pe=XE2YjKOMjUKPw2Ms5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnhcA-bzcMnR2BBPStb7XgZp2pe=XE2YjKOMjUKPw2Ms5w@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 09:35:57PM +0900, Tomoya MORINAGA wrote:

> Do you mean you cannot review this codec driver any more unless I
> provide other 2 drivers (machine and platform) ?

No.  This is the review of the machine driver.  The machine driver
depends on both the CODEC and the CPU drivers.
