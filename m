Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2KTOSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:18:55 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:38593 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KTOSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:18:54 -0500
MIME-Version: 1.0
In-Reply-To: <1353420249-17957-1-git-send-email-linus.walleij@stericsson.com>
References: <1353420249-17957-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 20 Nov 2012 19:48:53 +0530
Message-ID: <CAKohpo=7k2W6RSX1WMwi0kHbO3Hnr_7T4_LvOhru8YFRTo-34A@mail.gmail.com>
Subject: Re: [PATCH 1/7 v2] gpiolib: let gpiochip_add_pin_range() specify offset
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

On 20 November 2012 19:34, Linus Walleij <linus.walleij@stericsson.com> wrote:
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

For all 7 patches:
Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
