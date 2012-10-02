Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2JBJQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:16:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51099 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2JBJQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:16:25 -0400
MIME-Version: 1.0
In-Reply-To: <1349165603-24401-4-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
	<1349165603-24401-4-git-send-email-lee.jones@linaro.org>
Date: Tue, 2 Oct 2012 11:16:23 +0200
Message-ID: <CACRpkdatjOMxS_pQNPQjoNXgSTYhh7iQoxhKGzdTL=bdQMtwvg@mail.gmail.com>
Subject: Re: [PATCH 03/10] Input: bu21013_ts - Request a regulator that
 actually exists
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

> Currently the BU21013 Touch Screen driver requests a regulator by the
> name of 'V-TOUCH', which doesn't exist anywhere in the kernel. The
> correct name, as referenced in platform regulator code is 'avdd'. Here,
> when we request a regulator, we use the correct name instead.
>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Mark Brown requested this (real) name of the regulator a while back.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

This should go separately into the -rc fixes or directly upstream.

Yours,
Linus Walleij
