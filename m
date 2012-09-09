Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2IIU6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:58:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56705 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2IIU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:58:13 -0400
Date: Sun, 9 Sep 2012 21:57:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Turquette <mturquette@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Mark Brown <broonie@sirena.org.uk>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Make the managed clk functions generically
	available
Message-ID: <20120909205703.GJ13739@n2100.arm.linux.org.uk>
References: <1347202862-1617-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347202862-1617-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 05:01:02PM +0200, Lars-Peter Clausen wrote:
> The managed clk functions are currently only available when the generic clk
> lookup framework is build. But the managed clk functions are merely wrappers
> around clk_get and clk_put and do not depend on any specifics of the generic
> lookup functions and there are still quite a few custom implementations of the
> clk API. So make the managed functions available whenever the clk API is
> implemented.
> 
> The patch also removes the custom implementation of devm_clk_get for the
> coldfire platform.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Definitely-Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks for finally cooking up a patch for this.
