Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1FITht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:37:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab1FIThr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:37:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH v3 06/12] MFD: twl4030-codec -> twl4030-audio: Rename the driver
Date: Thu, 9 Jun 2011 21:37:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
References: <1307626230-29660-1-git-send-email-peter.ujfalusi@ti.com> <1307626230-29660-7-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1307626230-29660-7-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106092137.28678.arnd@arndb.de>
X-Provags-ID: V02:K0:thpS92fORp1DItmkJLFSm0BnaLxlnJUZSM0LbacderG
 UBpsHZE3MtVGM8337kTdIPQFMW2OtlXzpxr4+FSm61zjw/zHbS
 nT2y3TkCDXzsoiWCBkherD/MxtxER2a0oIek/qXGfLfFGC177T
 wa82DIhVbtAOeimeATdy1gIytDcw7EYfDdH7NbACw3OnYgjt1H
 uqs3BAVrKka49jz3K+z8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 15:30:24 Peter Ujfalusi wrote:
> Rename the driver, and header file from twl4030-codec to
> twl4030-audio.
> To avoid breakage change depending drivers at the same time.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Misael Lopez Cruz <misael.lopez@ti.com>
> ---
>  drivers/input/misc/Kconfig         |    2 +-
>  drivers/input/misc/twl4030-vibra.c |   10 +-
>  drivers/mfd/Kconfig                |    2 +-
>  drivers/mfd/Makefile               |    2 +-
>  drivers/mfd/twl4030-audio.c        |  277 +++++++++++++++++++++++++++++++++++
>  drivers/mfd/twl4030-codec.c        |  278 ------------------------------------
>  include/linux/mfd/twl4030-audio.h  |  272 +++++++++++++++++++++++++++++++++++
>  include/linux/mfd/twl4030-codec.h  |  272 -----------------------------------

Better use the -M flag to git-format-patch when moving files, to make it
obvious what has or has not changed, and to reduce the size of the email.

Also, shouldn't this file go into the sound/soc/ directory? It seems that this
is really the device driver, not part of the multi-function layer.

	Arnd
