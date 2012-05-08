Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2EHM05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:26:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45946 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2EHM0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <201205041934.08830.arnd@arndb.de>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
	<201205041934.08830.arnd@arndb.de>
Date: Tue, 8 May 2012 14:26:54 +0200
Message-ID: <CACRpkdb4LGXfJ72uODr841O7M4FGTYKa1X7y6ekeLUw9vaL=mw@mail.gmail.com>
Subject: Re: Handling of modular boards
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 9:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Thanks for getting the discussion started. I've seen the same issue come
> up for arch/arm/mach-ux500/board-mop500*uib.c and for the beaglebone.
> I'm sure there are many more, but we should make sure that everyone
> of these can live with whatever we come up with.

The same issue sort of comes up with any system that uses the idiom
to have a few GPIO lines indicate in a binary code what version of the
board we're dealing with and what devices are thus on it, right?

We have this issue for the U9540 reference design and potentially
on the Snowball as well.

Yours,
Linus Walleij
