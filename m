Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2ICLKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:10:25 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42838 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab2ICLKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
Date: Mon, 3 Sep 2012 13:10:23 +0200
Message-ID: <CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
Subject: Re: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Arun MURTHY <arun.murthy@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 12:30 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> This commit moves the driver to drivers/pwm and converts it to the new
> PWM framework.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> Note: I'll take this through the PWM tree, but I'd like to have it
> acknowledged by a few people who know the hardware and can actually
> test whether this still works.

Pls include Arun on these patches, he'll know best if it'll work or
not.

I have one generic question: will this alter the layout of sysfs so we
need to change userspace? I had such issues before when moving
drivers to new busses...

Yours,
Linus Walleij
