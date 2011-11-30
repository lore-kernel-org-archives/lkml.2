Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1K3PsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:48:12 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38538 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab1K3PsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:48:11 -0500
MIME-Version: 1.0
In-Reply-To: <201111301330.52801.arnd.bergmann@linaro.org>
References: <1322656381-6496-1-git-send-email-linus.walleij@stericsson.com>
	<201111301330.52801.arnd.bergmann@linaro.org>
Date: Wed, 30 Nov 2011 23:48:10 +0800
Message-ID: <CAN1soZy5iDqBRHTV5tzn_y4WqvmP38LsULdGvTjuKKkR4=Wy1Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: make it possible to add multiple maps
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 9:30 PM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> On Wednesday 30 November 2011, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> Since we now anyway make a copy of the platform-supplied pinmux
>> map, we can just as well make it possible to call the function
>> adding maps several times, so as to simplify cases (as PXA) where
>> several sets of disparate mappings need to be added depending on
>> target platform.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Acked-by: Arnd Bergmann <arnd@linaro.org>
> --
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
