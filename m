Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2JBJUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:20:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57848 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2JBJUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <1349165603-24401-6-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
	<1349165603-24401-6-git-send-email-lee.jones@linaro.org>
Date: Tue, 2 Oct 2012 11:20:29 +0200
Message-ID: <CACRpkdahgNCbTbfYSwhHOaqrjcuTByoxTjwmA=u=+htHpYdQjg@mail.gmail.com>
Subject: Re: [PATCH 05/10] Input: bu21013_ts - Add support for Device Tree booting
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 10:13 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Now we can register the BU21013_ts touch screen when booting with
> Device Tree enabled. Here we parse all the necessary components
> previously expected to be passed from platform data.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
