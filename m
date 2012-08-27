Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2H0XkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:40:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61945 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2H0XkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <201208231426.43105.arnd@arndb.de>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
	<1345648390-4234-2-git-send-email-arnd@arndb.de>
	<201208231426.43105.arnd@arndb.de>
Date: Mon, 27 Aug 2012 16:40:11 -0700
Message-ID: <CACRpkdYbyrXRYTujEsKPofEpw01S8_B8b97edO-SpHjgfJ6V1Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] ARM: ux500: don't select LEDS_GPIO for snowball
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 7:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> I discussed this with Lee on IRC, he really wants to keep the LED enabled for snowball
> for his own convenience. How is this version instead?

Sure, I guess you already merged it though?

Acked-by.

Yours,
Linus Walleij
