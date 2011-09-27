Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab1I0Ho4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:44:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38472 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1I0Hoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1738180167@HQMAIL01.nvidia.com>
References: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321751@HQMAIL01.nvidia.com>
	<CACRpkdZyhkydTutHXfry_dUPK_Ts_jq+5VHcr8XdgrHSExTyww@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1738180167@HQMAIL01.nvidia.com>
Date: Tue, 27 Sep 2011 09:44:55 +0200
Message-ID: <CACRpkdZOBSz-v=_87c+tq3vGheXjYKGac=Gs03-rXApZc8Vv1Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v7
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 9:45 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Wednesday, September 21, 2011 3:17 AM:
>>
>> Great, I'm hunting your Acked-by/Reviewed-by ...
>
> Very close; I was just holding off until we resolved the discussion on
> hog'd non-system mapping table entries, and I figured I'd wait until v8
> which presumably would delete the pinmux_config function from the header?

Yep, I will submit that soon. After this I plan to request its inclusion
into linux-next.

Yours,
Linus Walleij
