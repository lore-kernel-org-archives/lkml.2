Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2FGLH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:07:58 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38090 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab2FGLH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <1338913329-24245-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1338913329-24245-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 7 Jun 2012 13:07:56 +0200
Message-ID: <CACRpkdbLjPtjPuH+AnVedtraPvAUMierjh+7dTYscMQz224vaQ@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: wm8994: Convert to devm_kzalloc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 6:22 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/gpio/gpio-wm8994.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Nice!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
