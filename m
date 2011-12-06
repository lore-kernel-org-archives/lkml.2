Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab1LFKZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:25:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41016 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933052Ab1LFKZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:25:23 -0500
Date: Tue, 6 Dec 2011 10:25:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: "Austin, Brian" <Brian.Austin@cirrus.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mike Frysinger <vapier@gentoo.org>,
        "qi.wang@intel.com" <qi.wang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>,
        Daniel Mack <zonque@gmail.com>, Liam Girdwood <lrg@ti.com>,
        "joel.clark@intel.com" <joel.clark@intel.com>
Subject: Re: [alsa-devel] [PATCH v2] soc/lapis: add machine driver
Message-ID: <20111206102519.GD28840@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
 <20111202153401.GX8245@opensource.wolfsonmicro.com>
 <CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
 <20111205183223.GB7467@opensource.wolfsonmicro.com>
 <CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
 <057C8CCF-453E-4DC2-8E22-3D260973D35E@cirrus.com>
 <CANKRQniQSUWyaKUcn24ungmAu0ABHhBZ1=YhGz5jAp02X=KTAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQniQSUWyaKUcn24ungmAu0ABHhBZ1=YhGz5jAp02X=KTAA@mail.gmail.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:37:52AM +0900, Tomoya MORINAGA wrote:

> Thanks.  However, i2c access code is not included in Samsung.
> Though OMAP includes i2c access code like below,
>   omap/sdp3430.c: twl_i2c_read_u8(TWL4030_MODULE_INTBR, &pin_mux,
>   omap/sdp3430.c: twl_i2c_write_u8(TWL4030_MODULE_INTBR, pin_mux,
> this code doesn't seem applicable for me.

> Could you show best practice for i2c access of machine driver?

I2C access by machine drivers is not good practice.  If you must do it
for some reason use the standard ASoC functions to read and write
registers.
