Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2BVGRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:17:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43754 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2BVGRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:17:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.160.131 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC309@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-5-git-send-email-swarren@nvidia.com>
	<CACRpkdYCkRrvt+2B2nzAR+4XTeZo=N+OVA49TuExHCwsLAExwg@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BC309@HQMAIL01.nvidia.com>
Date: Wed, 22 Feb 2012 07:17:50 +0100
Message-ID: <CACRpkdZWwe4KCLUhzpeUBLPJrLkvCdzHs7ZRMvnq64a-8cbNug@mail.gmail.com>
Subject: Re: [PATCH 04/20] pinctrl: Record a pin owner, not mux function, when
 requesting pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 6:23 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, February 20, 2012 2:15 PM:
>> >
>> > -       if (!function) {
>> > -               dev_err(pctldev->dev, "no function name given\n");
>> > -               return -EINVAL;
>> > -       }
>> > -
>>
>> Why should it be allowed to have a NULL owner? There is a
>> debug print involving it above but ... maybe this is over-cautious?
>
> My reasoning was that this is an internal function, so this isn't a user-
> supplied parameter we need to be paranoid about checking, and the places
> that call this function internally "obviously" don't pass NULL owner.
> Well, I suppose one place relies on the fact we checked elsewhere that
> map->dev_name != NULL.
>
> Still, I can see a defensive programming argument for keeping that check,
> although I suspect if we apply that argument we should probably check a
> lot more things too throughout the code?

Bah whatever, no big deal.

Patch applied!

Thanks,
Linus Walleij
