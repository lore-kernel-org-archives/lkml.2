Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab2IJM4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:56:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63878 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab2IJM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-14-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-14-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 05:56:19 -0700
Message-ID: <CACRpkdYEXWbLN_HA98+HWu8HXH1Z=Sd_W=o5mnCxJJyJPMR_0A@mail.gmail.com>
Subject: Re: [PATCH 13/19] ARM: ux500: Stop registering I2C sub-devices for
 HREF when DT is enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we remove all calls to register I2C sub-devices from platform
> code when Device Tree is enabled. Instead the I2C driver will parse
> the Device Tree for them.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>
(But you need the deps in place first, of course.)

Yours,
Linus Walleij
