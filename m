Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2GEMka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:40:30 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55723 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2GEMk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:40:26 -0400
MIME-Version: 1.0
In-Reply-To: <1338913329-24245-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1338913329-24245-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 5 Jul 2012 14:40:25 +0200
Message-ID: <CACRpkdYydChsTr2xNxYXVsH3G+1kF+KQ0VvXDXP3_etNW2xpGA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: wm8994: Convert to devm_kzalloc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 6:22 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/gpio/gpio-wm8994.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Patch applied.

Thanks,
Linus Walleij
