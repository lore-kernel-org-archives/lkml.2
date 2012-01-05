Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2AEN7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:59:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51830 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2AEN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbLMW-SXnr6hbpwMqG=-a0wmYtU+YnyR8uLsndUp=UBgQ@mail.gmail.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-3-git-send-email-b29396@freescale.com>
	<CACRpkdbLMW-SXnr6hbpwMqG=-a0wmYtU+YnyR8uLsndUp=UBgQ@mail.gmail.com>
Date: Thu, 5 Jan 2012 21:59:51 +0800
Message-ID: <CAA+hA=TMoj9uCuSCBf1J3a_sJ5HpGZwB3Ua769OKFeoLVMooyg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Dong Aisheng <dongas86@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, cjb@laptop.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 1, 2012 at 10:07 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Dec 20, 2011 at 6:40 PM, Dong Aisheng <b29396@freescale.com> wrote:
>
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> This patch provies a common API for driver to use to register pinmux
>> mappings from dts file. It is needed for dt support.
>
> Overall I feel lost in this discussion due to limited exposure to
> device tree concepts. If I get Stephen Warrens and one of the
> DT people's (Rob, Grant) ACK on this I'll be happy to merge it.
>
> Until then, I guess it will need to be refined for the next kernel
> cycle.
>
Yes, i refined the patch and sent out again.
The main issue formerly discussed are where to place the pinmux map
for binding.
The new found is that if we use the way as regulator does on dt binding,
it seems we do not need define pinmux map in dts file since the device node
relationship already reflects it.
I'm not sure if it's suitable for pinctrl subsystem,
but I tried that way in the new patch i sent.
However, it still have a few issues that it does not support hog_on_boot via
dt and does not support multi groups since the usage is a little
different without
pinmux map.
We may still need some discussion on how to cover that two issue.

Regards
Dong Aisheng
