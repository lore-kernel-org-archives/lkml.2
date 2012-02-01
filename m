Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2BASlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:41:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53669 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab2BASlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:41:22 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E12470D@HQMAIL01.nvidia.com>
References: <1328117053-27807-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF178E12470D@HQMAIL01.nvidia.com>
Date: Wed, 1 Feb 2012 19:41:21 +0100
Message-ID: <CACRpkdbGwfR37HQ=QUEooyVzJ2zoD0bjaZ_-TSaFGiBZG_dTCQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: delete raw device pointers in pinmux maps
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 6:37 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Wednesday, February 01, 2012 10:24 AM:
>> After discussion with Mark Brown in an unrelated thread about
>> ADC lookups, it came to my knowledge that the ability to pass
>> a struct device * in the regulator consumers is just a
>> historical artifact, and not really recommended. Since there
>> are no in-kernel users of these pointers, we just kill them
>> right now, before someone starts to use them.
>>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> I didn't review the code, but just wanted to note that
> Documentation/pinctrl.txt needs some updates too, e.g. "Pinmux
> board/machine configuration" says:

Good catch! Spinning a v2 with that removed.

Thanks,
Linus Walleij
