Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2ELHBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 03:01:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57863 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2ELHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 03:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205040047280.18111@axis700.grange>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-4-git-send-email-thomas.abraham@linaro.org>
	<Pine.LNX.4.64.1205040047280.18111@axis700.grange>
Date: Sat, 12 May 2012 12:31:28 +0530
Message-ID: <CAJuYYwQj7gzZ9piJAJLcf7SiyJnQ6nZ63-X9ieQ-FCj6TNhQPQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] mmc: dw_mmc: add device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 May 2012 04:18, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>
> What do you think about this patch
>
> http://www.spinics.net/lists/linux-sh/msg11259.html
>
> and about using mmc-generic OF properties instead of creating yet another
> copy of proprietary ones?

Hi Guennadi,

This patch does not intend to add any custom mmc properties. I checked
your patch (in the link mentioned above) and most of the bindings are
similar to what you have come up with except for the "ro-gpios" for
which I have used "wp-gpios". But this is following what Arnd had
proposed here: http://www.spinics.net/lists/linux-mmc/msg13564.html.

Regarding the MMC_CAP_4_BIT_DATA and MMC_CAP_8_BIT_DATA in your patch,
these can be derived from the bus width information that the driver
receives.

Thanks,
Thomas.
