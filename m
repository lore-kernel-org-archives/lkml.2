Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab0KYKrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:47:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58166 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0KYKrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:47:18 -0500
Subject: Re: [PATCH] ASoC: Fix compile error for smartq_wm8987.c
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org
In-Reply-To: <1290663829.30158.5.camel@mola>
References: <1290663829.30158.5.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 10:47:14 +0000
Message-ID: <1290682034.3302.13.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 13:43 +0800, Axel Lin wrote:
> Fix below compile error:
> 
>   CC      sound/soc/samsung/smartq_wm8987.o
> sound/soc/samsung/smartq_wm8987.c: In function 'smartq_hifi_hw_params':
> sound/soc/samsung/smartq_wm8987.c:42: error: 'struct snd_soc_pcm_runtime' has no member named 'dai'
> sound/soc/samsung/smartq_wm8987.c:43: error: 'struct snd_soc_pcm_runtime' has no member named 'dai'
> sound/soc/samsung/smartq_wm8987.c: In function 'smartq_wm8987_init':
> sound/soc/samsung/smartq_wm8987.c:192: warning: passing argument 1 of 'snd_soc_jack_new' from incompatible pointer type
> sound/soc/samsung/smartq_wm8987.c: At top level:
> sound/soc/samsung/smartq_wm8987.c:216: warning: initialization from incompatible pointer type
> make[3]: *** [sound/soc/samsung/smartq_wm8987.o] Error 1
> make[2]: *** [sound/soc/samsung] Error 2
> make[1]: *** [sound/soc] Error 2
> make: *** [sound] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Liam Girdwood <lrg@slimlogic.o.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

