Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0FWXYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 19:24:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36314 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752441Ab0FWXYU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 19:24:20 -0400
Subject: Re: [PATCH] ASoC: DaVinci: Added support for stereo I2S
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1277303635-5675-1-git-send-email-lamiaposta71@gmail.com> (sfid-20100623_154205_545825_0E9CDE5F)
Date: Thu, 24 Jun 2010 00:24:16 +0100
Cc: davinci-linux-open-source@linux.davincidsp.com,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Russell King <linux@arm.linux.org.uk>,
       Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ACF70CBE-6096-431C-A5A1-E3700642EB53@opensource.wolfsonmicro.com>
References: <1277303635-5675-1-git-send-email-lamiaposta71@gmail.com> (sfid-20100623_154205_545825_0E9CDE5F)
To: Raffaele Recalcati <lamiaposta71@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 Jun 2010, at 15:33, Raffaele Recalcati wrote:

> From: Raffaele Recalcati <raffaele.recalcati@bticino.it>
> 
> 	Added audio playback support with [frame sync master - clock master] mode
> 	and with [frame sync master - clock slave].
> 	Clock slave can be important when the external codec need system clock
> 	and bit clock synchronized.
> 	In the clock master case there is a FIXME message in the source code, because we
> 	(Davide and myself) have guessed a frequency of 122000000 that seems the base
> 	to be divided.
> 	This patch has been developed against the
> 		http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
> 	git tree and has been tested on bmx board (similar to dm365 evm, but using
> 	uda1345 as external audio codec).
> 
> Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
> Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>

I'd pretty much echo what Liam said - I'm not 100% sure from your description what the
patch is supposed to do and the code isn't particularly clear either. It *looks* like you're
trying to add a new clock source, but from the description this appears to be an
externally visible clock which makes it very unclear why you have to guess the frequency.