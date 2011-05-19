Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1ESMVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:21:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51475 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab1ESMV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110519085638.GA26816@S2100-06.ap.freescale.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<20110519085638.GA26816@S2100-06.ap.freescale.net>
Date: Thu, 19 May 2011 14:21:27 +0200
Message-ID: <BANLkTinD9rAipfwNnh6QpgbcogckdtQ=OQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:56 AM, Shawn Guo <shawn.guo@freescale.com> wrote:

> I start working on moving mxs gpio (arch/arm/mach-mxs/gpio.c) into
> driver/gpio, and I see the possibility to go a different approach
> from U300 one posted here.

I've tried to figure out what relation the mail has to the U300 driver
but cannot find any, more than that it's moving a driver... Please
start a new mail thread.

Linus Walleij
