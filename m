Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2JBJSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:18:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34593 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2JBJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <1349165603-24401-5-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
	<1349165603-24401-5-git-send-email-lee.jones@linaro.org>
Date: Tue, 2 Oct 2012 11:18:32 +0200
Message-ID: <CACRpkdYE1GgLPMjQ-Oz_ap022OykhfK8D7BoN6oTXGYwttxN9A@mail.gmail.com>
Subject: Re: [PATCH 04/10] Input: bu21013_ts - Move GPIO init and exit
 functions into the driver
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

> These GPIO init and exit functions have no place in platform data.
> Instead they should be part of the driver. This patch moves them to
> their rightful place, which subsequently elevates platform data of
> yet more cruft.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
