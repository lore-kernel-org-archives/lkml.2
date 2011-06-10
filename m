Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1FJExE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 00:53:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33838 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab1FJExC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 00:53:02 -0400
From: =?iso-8859-15?q?P=E9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 06/12] MFD: twl4030-codec -> twl4030-audio: Rename the driver
Date: Fri, 10 Jun 2011 07:52:51 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo; KDE/4.6.3; x86_64; ; )
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
References: <1307626230-29660-1-git-send-email-peter.ujfalusi@ti.com> <1307626230-29660-7-git-send-email-peter.ujfalusi@ti.com> <201106092137.28678.arnd@arndb.de>
In-Reply-To: <201106092137.28678.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-ID: <201106100752.51718.peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 22:37:28 Arnd Bergmann wrote:
> Better use the -M flag to git-format-patch when moving files, to make it
> obvious what has or has not changed, and to reduce the size of the email.

I tend to forgot the -M flag, thanks.
 
> Also, shouldn't this file go into the sound/soc/ directory? It seems that
> this is really the device driver, not part of the multi-function layer.

This driver is the MFD core part for the audio block within the twl4030 series 
pmic.
We have the slave drivers under sound/soc/codecs/twl4030.c and 
drivers/input/misc/twl4030-vibra.c.
The audio block has codec, and vibra functionality, and we need to have this 
driver to properly manage this block within twl.

-- 
Péter
