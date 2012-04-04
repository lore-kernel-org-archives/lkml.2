Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2DDIxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:53:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65322 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab2DDIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:53:16 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.129.146]
Date: Wed, 4 Apr 2012 10:53:15 +0200
Message-ID: <CAORVsuWw1rwcsMUrSqZJCeSY_vjJDwakF27kfb6=utN8nBqvag@mail.gmail.com>
Subject: gpiolib: per-gpio edges count
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Linus,

I would like to know if it is possible to get the edges count on a GPIO pin.
I was hoping to get it by configuring the pin as input with an edge
trigger but on OMAP there is only one irq line per controller (which
controls 32 pins).
Btw I am using a Beaglebone with OMAP AM3358.

The options I see now are:
- use select/poll on the value in sysfs and count the edges in user
space. This looks like overkill for the task though.
- hack the gpiolib code to export an irq count and timestamp to sysfs.

What do you think?

Regards,
Jean Pihet
