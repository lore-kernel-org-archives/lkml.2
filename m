Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2JBJHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:07:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43347 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2JBJHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:07:49 -0400
MIME-Version: 1.0
In-Reply-To: <1349165603-24401-3-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
	<1349165603-24401-3-git-send-email-lee.jones@linaro.org>
Date: Tue, 2 Oct 2012 11:07:48 +0200
Message-ID: <CACRpkdZDO7NRGr7ON6_EpsQzqcBbfO8Dx4M3yWphBgn6y3bnrA@mail.gmail.com>
Subject: Re: [PATCH 02/10] ARM: ux500: Strip out duplicate touch screen
 platform information
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 10:13 AM, Lee Jones <lee.jones@linaro.org> wrote:

> We're currently carrying two 'struct bu21013_platform_device's which
> are identical for no apparent reason. Here we remove the extra burden
> and apply the same information to the two different instances of the
> bu21012_tp driver registration.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Makes perfect sense.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
