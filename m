Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2KUH4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:56:49 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47520 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KUH4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <1353483465-25961-1-git-send-email-linus.walleij@stericsson.com>
References: <1353483465-25961-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 21 Nov 2012 08:56:47 +0100
Message-ID: <CACRpkdZSfyffBCZ7jorxV28qpeSt37HV2cPaBcyqA1QPNwjmcw@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix bug and clarify OF use of ranges
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 8:37 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> In commit c905165f5946f56dca195871641bd4e488eca24a
> "gpiolib: let gpiochip_add_pin_range() specify offset"
> I forgot to update the OF use of the function
> gpiochip_add_pin_range().
>
> It turns out that this reveal a weakness in the
> OF range mappings: ranges cannot currently be sparse.
> So put in a comment so we can fix this later.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

BTW I've squashed this into the original commit above to avoid any
git bisect issues.

Linus Walleij
