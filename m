Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1JBSGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:06:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64697 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1JBSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:06:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 21/30] sound/soc/omap: limit to omap2plus
Date: Sun, 02 Oct 2011 20:03:38 +0200
Message-ID: <4511363.OPCpQMvKWi@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002204035.2e5b98943ed5137fd689b9be@bitmer.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-22-git-send-email-arnd@arndb.de> <20111002204035.2e5b98943ed5137fd689b9be@bitmer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hy46kuM8B6UioX8cbHWsjV7EEshP4/pucbWnWvSOpJk
 sfggswmlRK1xGaZpmYGHeF9x0mMUeHueg/AjNrjlmY8sYffL/A
 l3g91U+PG2VpLjmeZh9QTRKfh1cGuULn7Fmijd37gaiP4yzPHv
 Q0hrHLpeVyfcjwEl4prxeGAoCKdlTba35kF6XeSGCZAP758Jgb
 Ui3yU4y6nPnYnZ1wI+XE2t5yqLAapx6+aDaEBbgZ0agkQ0mg7M
 4D/O4FUSWaxFu+Q1iRsL03GF/qOvz9SH2/Kn8vk5H22Qpnn/Ln
 XT1kYvLU1D4xU/rxYo5RUvIdO1dZ30eWEFzMuNclSepKx+bphY
 0psCwym3exDd3oIt4Pxk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 20:40:35 Jarkko Nikula wrote:
> Strange. I'm able to build them fine with omap1_defconfig and with two
> supported OMAP1 ASoC machine drivers we have:
> 
> CONFIG_SND_OMAP_SOC_AMS_DELTA=y
> CONFIG_SND_OMAP_SOC_OSK5912=y
> 
> What's the error you are seeing? I guess there might be some missing
> dependency that doesn't get visible with omap1_defconfig.
> 
> I would like to get that fixed instead of disabling OMAP1 ASoC support
> as the ams-delta in kernel is alive device thanks to active developer
> Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>.

I no longer have the original bug, maybe it was a false positive.
I'll drop this patch and have another look if the problem comes back.

Thanks for taking a closer look!

	Arnd
