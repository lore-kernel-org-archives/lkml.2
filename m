Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1H1UH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 16:07:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56219 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1H1UHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 16:07:21 -0400
Date: Sun, 28 Aug 2011 21:06:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: Fix builderror in spi-pl022.c
Message-ID: <20110828200648.GC13379@n2100.arm.linux.org.uk>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk> <1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 09:26:59PM +0200, Peter Huewe wrote:
> This patch fixes a build error, introduced by commit (67fc8b9f, "PM: add
> runtime PM support to core Primecell driver") which unfortunately was a little
> bit incomplete and did contain a typo (11 instead of 22).
> I'm not sure how this patch could have been tested back then, if it
> doesn't even compile ;)

Maybe it was tested on configs without CONFIG_SUSPEND enabled - which
is highly likely since my ARM development boards don't support S2RAM.

That's the problem with ifdef'ing code.  It makes it impossible to
ensure that it's properly tested.
