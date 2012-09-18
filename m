Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab2IRMYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:24:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952Ab2IRMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:24:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] ARM: ux500: tidy up pin sleep modes
Date: Tue, 18 Sep 2012 12:24:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1347967598-24691-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1347967598-24691-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181224.36834.arnd@arndb.de>
X-Provags-ID: V02:K0:XtJO0BxKg9ALR4N3UJlPOedCQtG/KiVis9QouNDOyZf
 3Hv+ZmHDMfc+PKUhyv+xWsZdoxMM4B3n9efebl+h3v0lwWTRd/
 kIIKvZ81p5FIgaoohUbcvcBjBe/KAvT5W99sYCJNoUIImJiGJx
 HqWnOJMCrczF4W3/fW22Y6wXukaWm6AnKnqLsoYs7rjmZDXkyz
 VAaYjU3Wcf1r0vMaAyZB0RXK4puK/iLhP4UKFajVW9EXtz+DiB
 4QgQSfi4ehNq+uQsHjYuU7+N0l7Dv9y0MmJoEBgMoqPf0Av3eU
 Tu1+SPqCR5DXr1uc1KKORoBcwWqJAAeIQHQnN9Gu0dtZC3EVU3
 q3d4Wi+QAjDqmrrnpkEE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This named the sleep mode pin configurations as slpm rather
> than sleep to correspond better with the settings from the
> datasheet. It also defines an optional sleep mode for the SPI
> controller SPI2.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Arnd, Olof: again a patch I'd like to take through the pinctrl
> tree for simplicity.

Acked-by: Arnd Bergmann <arnd@arndb.de>
