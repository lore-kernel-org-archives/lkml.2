Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BOSpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:45:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33819 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2BOSpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:45:24 -0500
MIME-Version: 1.0
In-Reply-To: <1329138752.2982.2.camel@phoenix>
References: <1329138752.2982.2.camel@phoenix>
Date: Wed, 15 Feb 2012 19:45:23 +0100
Message-ID: <CACRpkdZNbNL_o+R30h0EY133KgmOwMYwsjFT8X3Mu1sUFRf5RQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/leds/leds-lm3530.c: Move the code setting
 gen_config to one place
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 2:12 PM, Axel Lin <axel.lin@gmail.com> wrote:

> Improve the readability by moving the code setting gen_config to one place.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks correct to me:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks
Linus Walleij
