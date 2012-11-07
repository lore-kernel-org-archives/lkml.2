Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab2KGFO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 00:14:59 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56021 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2KGFO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 00:14:58 -0500
MIME-Version: 1.0
In-Reply-To: <1352215021-30341-1-git-send-email-linus.walleij@stericsson.com>
References: <1352215021-30341-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 7 Nov 2012 10:44:58 +0530
X-Google-Sender-Auth: M_8o-R1s_paBxE6X9SGejzMzQfg
Message-ID: <CAOh2x==PKDrOGrdxVTsqt6gr3K-0WPv800SYu3Ob=dNjnCW+NA@mail.gmail.com>
Subject: Re: [PATCH 4/5] gpiolib: call pin removal in chip removal function
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

On Tue, Nov 6, 2012 at 8:47 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This makes us call gpiochio_remove_pin_ranges() in the
> gpiochip_remove() function, so we get rid of ranges when
> freeing the chip.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
