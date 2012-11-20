Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2KTMzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:55:54 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39180 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2KTMzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <1353411953-27423-1-git-send-email-linus.walleij@stericsson.com>
References: <1353411953-27423-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 20 Nov 2012 18:25:52 +0530
Message-ID: <CAKohpo=u=8PbJ3886tcRrVujyYpPwe+QoRh5Gqk-=uxvMwYfRA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: let gpiochip_add_pin_range() specify offset
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 17:15, Linus Walleij <linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> Like with commit 3c739ad0df5eb41cd7adad879eda6aa09879eb76
> it is not always enough to specify all the pins of a gpio_chip
> from offset zero to be added to a pin map range, since the
> mapping from GPIO to pin controller may not be linear at all,
> but need to be broken into a few consecutive sub-ranges or
> 1-pin entries for complicated cases. The ranges may also be
> sparse.
>
> This alters the signature of the function to accept offsets
> into both the GPIO-chip local pinspace and the pin controller
> local pinspace.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

Aren't there any users of this routine?

--
viresh
