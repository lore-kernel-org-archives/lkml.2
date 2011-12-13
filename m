Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1LMHVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:21:45 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40945 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1LMHVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:21:41 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYFvRDegS63EQzp8pjRMUj7Ru57bK7a+Qq81OkBXmrCBQ@mail.gmail.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<CAN1soZztU+gC3tkzXK5m51-+djqqcC_JhiJyc4xys2K_ZxUnGA@mail.gmail.com>
	<CACRpkdYFvRDegS63EQzp8pjRMUj7Ru57bK7a+Qq81OkBXmrCBQ@mail.gmail.com>
Date: Tue, 13 Dec 2011 15:21:40 +0800
Message-ID: <CAN1soZw=51caZjEoxBx8ch0KiE-kgHQFA1amRcTOyDDKe5Ymzw@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 8:22 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Dec 12, 2011 at 7:19 AM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
>
>> You mentioned that pin_config_set() is used in below.
>> ret = pin_config_set(dev, "FOO_GPIO_PIN", PLATFORM_X_PULL_UP);
>>
>> struct pinctrl_dev is created while pinmux is registered. I think this
>> structure is always internal structure. It can't be observed by
>> platform driver or device driver.
>
> True. Was fixed today by a patch from Stephen Warren that
> simply cuts out the middleman and use the original platform
> device directly. Kudos to Stephen for fixing this!
>
> Linus Walleij

Excuse me that I didn't find that patch. Did you merge it into your
git tree? The latest patch on pinconf.c is updating pdev->dev to
&pdev->dev.

By the way, will you merge generic-pinconf into your for-next branch?

Best Regards
Haojian
