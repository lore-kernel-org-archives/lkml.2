Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1HMG3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:29:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43655 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751121Ab1HMG3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:29:38 -0400
Date: Sat, 13 Aug 2011 15:29:26 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [linux-next] ASoC: sound/soc/samsung/i2s.c build failure
Message-ID: <20110813062925.GB16171@opensource.wolfsonmicro.com>
References: <1313208043.29596.11.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313208043.29596.11.camel@phoenix>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 12:00:43PM +0800, Axel Lin wrote:
>   CC      sound/soc/samsung/i2s.o
> sound/soc/samsung/i2s.c:24:18: error: idma.h: No such file or directory
> sound/soc/samsung/i2s.c: In function 'samsung_i2s_dai_probe':
> sound/soc/samsung/i2s.c:883: error: implicit declaration of function 'idma_reg_addr_init'
> make[3]: *** [sound/soc/samsung/i2s.o] Error 1
> make[2]: *** [sound/soc/samsung] Error 2
> make[1]: *** [sound/soc] Error 2
> make: *** [sound] Error 2

> It is caused by commit a0c27ab2421c47dc7c53f797fffcc0d17cdb122c
> ASoC: Revert "ASoC: SAMSUNG: Add I2S0 internal dma driver"

> To fix the build error, I think we also need to revert
> commit 61100f405de5c16a0866de7843ed442090436e6a
> "ASoC: SAMSUNG: Modify I2S driver to support idma".

This is already fixed by cherry picking back the original commit, it
depended on some stuff from Kukjin's tree.
