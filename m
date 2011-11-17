Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1KQIBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:01:08 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34380 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1KQIBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:01:07 -0500
MIME-Version: 1.0
In-Reply-To: <1321339226-29968-1-git-send-email-rnayak@ti.com>
References: <1321339226-29968-1-git-send-email-rnayak@ti.com>
Date: Thu, 17 Nov 2011 09:01:06 +0100
Message-ID: <CACRpkdaK6vFqfZ7_ccizunqqD+8KqBG8vkzRG5mszMxmtwjeDQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Iterate over u300_pmx_mask's in u300_pmx_endisable
From: Linus Walleij <linus.walleij@linaro.org>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 7:40 AM, Rajendra Nayak <rnayak@ti.com> wrote:

> Fix u300_pmx_endisable() to iterate over the list of 'bits' and
> 'mask' populated as part of u300_pmx_functions.mask[]
>
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> ---
> Linus W,
> I am not sure if this is a right fix. I just stumbled
> upon this while looking at the u300 pinmux driver
> while I was writing one for OMAP. Maybe I am reading
> the code completely wrong, and I don't even have a
> way to test this, so its just compile tested with
> u300_defconfig.

Looks correct and works, I've just been saved by the fact that
most mux settings are in a good default mode when powering
on the system.

Thanks, applied!
Linus Walleij
