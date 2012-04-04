Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2DDOtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:49:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37385 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab2DDOtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:49:04 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.129.146]
In-Reply-To: <CAORVsuWw1rwcsMUrSqZJCeSY_vjJDwakF27kfb6=utN8nBqvag@mail.gmail.com>
References: <CAORVsuWw1rwcsMUrSqZJCeSY_vjJDwakF27kfb6=utN8nBqvag@mail.gmail.com>
Date: Wed, 4 Apr 2012 16:49:03 +0200
Message-ID: <CAORVsuUQbtC=SF9RP2g04mN-ksE8BU40ACfZvoyGUju=LRbwqg@mail.gmail.com>
Subject: Re: gpiolib: per-gpio edges count
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 4, 2012 at 10:53 AM, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> Hi Grant, Linus,
>
> I would like to know if it is possible to get the edges count on a GPIO pin.
> I was hoping to get it by configuring the pin as input with an edge
> trigger but on OMAP there is only one irq line per controller (which
> controls 32 pins).
> Btw I am using a Beaglebone with OMAP AM3358.

I figured it out, with the help from Kevin on IRC (thx!).

Indeed there is a per-pin IRQ count available in /proc/interrupts.
Sorry for the unconvenience.

Thanks & regards,
Jean
