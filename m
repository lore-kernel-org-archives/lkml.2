Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2JJJXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:23:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44816 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2JJJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VePqj3FViNrOcicHXhv9BzhJQgSg6KvA31HmdEFf7BXOg@mail.gmail.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349859841.10584.122.camel@smile>
	<CAOh2x=mNiL4k=v3YGexq7YMZUx131QWBpm11QXupnWLUPuKU4Q@mail.gmail.com>
	<CAHp75VePqj3FViNrOcicHXhv9BzhJQgSg6KvA31HmdEFf7BXOg@mail.gmail.com>
Date: Wed, 10 Oct 2012 14:53:33 +0530
Message-ID: <CAKohpo=LOpkzUFG8UV7VkTtq3vrm6WFg0qMwgrUL6PBFaCwBJQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] dmaengine: dw_dmac: use helper macro module_platform_driver()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 October 2012 14:51, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> We have spi, i2c and hsuart devices connected to the DMA controller.
> In case we would like to use DMA we have to have the dw_dmac loaded
> before them. Currently we have spi driver on subsys_initcall level,
> and Mika, who is developing it, will change to module_init_call level.
> However, it will just hide the potential issue. He also tried to use
> deferred module loading, but we don't know if it's good solution or
> not, and that solution requires something to stop deferring at some
> moment.
>
> Might be we missed something and there is a better solution.

My eyes aren't 6/6 now. I need specs now.
How could i miss that you just removed the very intentional subsys_init()
call. My bad.

I take my Acked-by: back :)

--
viresh
