Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab2KGFOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:14:21 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42662 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2KGFOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:14:20 -0500
MIME-Version: 1.0
In-Reply-To: <1352215014-30305-1-git-send-email-linus.walleij@stericsson.com>
References: <1352215014-30305-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 7 Nov 2012 10:44:20 +0530
X-Google-Sender-Auth: gIWquRInKFIHF0ucApF7_00YBVU
Message-ID: <CAOh2x=nT8_95uu9tfEnOHy9Gkm6gEEAVAKKwPAqbLJz3bwFDNw@mail.gmail.com>
Subject: Re: [PATCH 3/5] gpiolib: remove duplicate pin range code
From: viresh kumar <viresh.kumar@linaro.org>
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

On Tue, Nov 6, 2012 at 8:46 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> Commit 69e1601bca88809dc118abd1becb02c15a02ec71
> "gpiolib: provide provision to register pin ranges"
>
> Introduced both of_gpiochip_remove_pin_range() and
> gpiochip_remove_pin_ranges(). But the contents are exactly
> the same so remove the OF one and rely on the range deletion
> in the core.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I can't believe that i did this :(

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
