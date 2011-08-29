Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1H2JR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 05:17:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55766 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1H2JRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 05:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110829110435.e7f2a6ae1637a6b13f2c5874@canb.auug.org.au>
References: <20110829110435.e7f2a6ae1637a6b13f2c5874@canb.auug.org.au>
Date: Mon, 29 Aug 2011 11:17:21 +0200
Message-ID: <CACRpkdYgiDkgH8V7awhK66HxPAnFHzB3QhKj=VhMPn8UWwk5KQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 3:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Arnd,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-u300/Makefile.boot between commit 74b84ad6c1a5 ("ARM:
> 7022/1: allow to detect conflicting zreladdrs") from the arm tree and
> commit 732851465445 ("mach-u300: retire odd singlemem variant") from the
> arm-soc tree.
>
> I fixed it up (see below) and can carry the fix as necessary.

Looks correct, and it's one of the unavoidable things as we clean up
the ARM tree, thanks a lot Stephen!

Yours,
Linus Walleij
