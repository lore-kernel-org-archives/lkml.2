Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1CNQkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:40:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33175 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1CNQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:40:15 -0400
MIME-Version: 1.0
In-Reply-To: <1299672158-4711-1-git-send-email-linus.walleij@stericsson.com>
References: <1299672158-4711-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 14 Mar 2011 17:40:14 +0100
Message-ID: <AANLkTi==Fj7g8ne9NxiAoPoWtKxEmJrd=Q4j--Y3A4cF@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: add a core driver for TI TPS61050/TPS61052 chips v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 1:02 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> The TPS61050/TPS61052 are boost converters, LED drivers, LED flash
> drivers and a simple GPIO pin chips.
>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jonas Aberg <jonas.aberg@stericsson.com>
> Cc: Ola Lilja <ola.o.lilja@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Sam, if you're happy with this MFD driver, I'd request you to merge this and the
the regulator driver [2/3] into the MFD tree if possible. The ux500
platform data
will have to wait, since I have now sent that tree upstream.

Yours,
Linus Walleij
