Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab1IBILw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:11:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62643 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108Ab1IBILt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:11:49 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B327A40C@HQMAIL01.nvidia.com>
References: <1314869552-5531-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B327A40C@HQMAIL01.nvidia.com>
Date: Fri, 2 Sep 2011 10:11:48 +0200
Message-ID: <CACRpkdZ1kNbtOqw=X1mmM-bA+Gg2BbmO5_CT0sSQtBCK_WdwYw@mail.gmail.com>
Subject: Re: [PATCH 2/4 v6] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 11:33 PM, Stephen Warren <swarren@nvidia.com> wrote:

>> +static const struct u300_pmx_func u300_pmx_functions[] = {
>> +     {
>> +             .name = "power",
>> +             .groups = { POWERGRP_INDEX },
>> +             /* Mask is N/A */
>> +     },
>
> Hmmm. That's a lot of _INDEX defines that'd need to be set up, at least
> to fully represent a chip like Tegra. Can the pinmux core be modified
> such that the group list is an array of names (char*) rather than the
> actual numeric IDs of the groups? Still, perhaps we could use the enum
> we already have for this, so perhaps it isn't a big deal...

Well I could think about a lot of ways to do this, but it's basically up
to the driver, the U300 is just some simple example of what you can
do, it's just trying to satisfy the API.

Maybe as part of writing the nVidia driver you find a clever
mechanism for doing this, if it's looking generally useful at that
point then let's move it to the core I'd say.

Thanks,
Linus Walleij
