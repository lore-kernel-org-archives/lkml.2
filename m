Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2ARHQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:16:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33927 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2ARHQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:16:40 -0500
MIME-Version: 1.0
In-Reply-To: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 18 Jan 2012 12:46:37 +0530
Message-ID: <CAJuYYwT+pNdt6G07Gx7TqkpGBQEnmMGxsHSE2mew9qUjO-ES5Q@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 9 December 2011 17:27, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The details of passed
> configurations are passed in an opaque unsigned long which may be
> dereferences to integer types, structs or lists on either side
> of the configuration interface.

In case of runtime pinmuxing, the pin configuration would also be
required to be setup in some cases. pin_config_set() is suitable to be
called from the platform code. In case of runtime pinmuxing in driver
code, is there any way to set the pin config also at runtime in driver
code?

Thanks,
Thomas.
